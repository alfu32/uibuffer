module tui_renderer

import term
import term.ui

pub struct EventTarget {
pub:
	event &ui.Event
pub mut:
	target &Drawable
}

pub interface Drawable {
	draw(mut ctx ui.Context)
	get_box() Box
	get_text_lines() []string
mut:
	style Style
	scroll term.Coord
	anchor term.Coord
	size term.Coord
	event_listeners map[ui.EventType][]EventListener
	dispatch_event(event &ui.Event, mut target Drawable)
	add_event_listener(t ui.EventType, el EventListener)
}

pub struct Viewport {
pub mut:
	event_listeners map[ui.EventType][]EventListener
	drawables       []Drawable
	ctx             &ui.Context
	status          string
	scroll          term.Coord = term.Coord{
		x: 0
		y: 0
	}
	anchor term.Coord = term.Coord{
		x: 0
		y: 0
	}
	size term.Coord = term.Coord{
		x: 144
		y: 44
	}
	style Style = Style{
		background: Color.black.to_ui_color()
		color: Color.white.to_ui_color()
		border_set: BorderSets{}.single_solid
		weight: .normal
	}
}

pub fn viewport_create() &Viewport {
	w, h := term.get_terminal_size()
	mut vp := &Viewport{
		drawables: []
		ctx: ui.init(ui.Config{
			skip_init_checks: true
		})
		anchor: term.Coord{
			x: 0
			y: 0
		}
		size: term.Coord{
			x: w
			y: h
		}
		scroll: term.Coord{
			x: 0
			y: 0
		}
		style: Style{
			background: Color.bright_blue.to_ui_color()
			color: Color.black.to_ui_color()
			border_set: BorderSets{}.single_solid_rounded
			weight: .normal
		}
	}

	mut event := fn [mut vp] (e &ui.Event, x voidptr) {
		if e.typ == .key_down && e.code == .escape {
			exit(0)
		}
		vp.dispatch_event(e, mut vp)
	}
	mut frame := fn [mut vp] (x voidptr) {
		vp.ctx.clear()
		vp.render()

		Style{
			background: Color.white.to_ui_color()
			color: Color.black.to_ui_color()
			border_set: BorderSets{}.single_solid
			weight: .normal
		}.apply_to_context(mut vp.ctx)
		vp.ctx.draw_text(0, vp.size.y, vp.status)
		vp.ctx.flush()
	}
	ctx := ui.init(
		user_data: &vp
		event_fn: event
		frame_fn: frame
		hide_cursor: true
		capture_events: true
	)
	vp.ctx = ctx
	return vp
}

pub fn (r Viewport) get_text_lines() []string {
	return []
}

pub fn (mut r Viewport) clear() {
	r.ctx.clear()
}

pub fn (mut r Viewport) add(dw Drawable) {
	r.drawables << dw
}

pub fn (mut r Viewport) add_event_listener(t ui.EventType, el EventListener) {
	r.event_listeners[t] << el
}

pub fn (r Viewport) draw(mut ctx ui.Context) {
	for dw in r.drawables {
		dw.draw(mut ctx)
	}
}

pub fn (mut r Viewport) render() {
	for dw in r.drawables {
		dw.draw(mut r.ctx)
	}
}

pub fn (mut r Viewport) dispatch_event(e &ui.Event, mut target Drawable) {
	r.status = '
		x : ${e.x}, y : ${e.y}, typ : ${e.typ}, height : ${e.height}, width : ${e.width}, direction : ${e.direction}, code : ${e.code}
	'.trim_indent()
	/*.filter(fn [e] (dw Drawable) bool {
		return dw.get_box().contains(x: e.x, y: e.y)
	})*/
	for mut dw in r.drawables {
		dw.dispatch_event(e, mut &dw)
	}
}

fn (r Viewport) get_box() Box {
	return Box{
		top: r.anchor.y
		right: r.anchor.x
		bottom: r.anchor.y + r.size.y
		left: r.anchor.x + r.size.x
	}
}

pub type EventListener = fn (event &ui.Event, mut target Drawable) bool

pub struct Rectangle {
pub mut:
	event_listeners map[ui.EventType][]EventListener
	text            string
	anchor          term.Coord = term.Coord{
		x: 0
		y: 0
	}
	size term.Coord = term.Coord{
		x: 4
		y: 4
	}
	scroll term.Coord = term.Coord{
		x: 0
		y: 0
	}
	style Style = Style{
		background: Color.black.to_ui_color()
		color: Color.white.to_ui_color()
		border_set: BorderSets{}.single_solid
		weight: .normal
	}
}

pub fn (mut r Rectangle) add_event_listener(t ui.EventType, el EventListener) {
	r.event_listeners[t] << el
}

pub fn (r Rectangle) draw(mut ctx ui.Context) {
	tx := r.get_text_lines()
	tl, tr, bl, br, ho, ve := r.style.border_set.borders()
	scroller_pos := r.scroll.y * r.size.y / tx.len
	page := '${scroller_pos.str()}/${tx.len} ${r.scroll.y}'
	r.style.apply_to_context(mut ctx)
	ctx.draw_text(r.anchor.x, r.anchor.y, '${tl}${ho}${pad_right(page, ho, r.size.x - 3)}${tr}')
	for l in r.anchor.y + 1 .. r.anchor.y + r.size.y - 1 {
		txl := r.scroll.y + (l - r.anchor.y - 1)
		if (l - r.anchor.y - 1) >= scroller_pos - 1 && (l - r.anchor.y - 1) <= scroller_pos + 1 {
			ctx.draw_text(r.anchor.x, l, '${ve}${' '.repeat(r.size.x - 2)}┃')
		} else {
			ctx.draw_text(r.anchor.x, l, '${ve}${' '.repeat(r.size.x - 2)}${ve}')
		}

		if txl < tx.len {
			ctx.draw_text(r.anchor.x + 1, l, pad_left(txl.str(), ' ', 2))
			ctx.draw_text(r.anchor.x + 4, l, tx[txl][0..r.size.x - 5])
		}
	}
	/// term.set_cursor_position(term.Coord{ x: r.anchor.x, y: r.anchor.y + r.size.y - 1 })
	ctx.draw_text(r.anchor.x, r.anchor.y + r.size.y - 1, '${bl}${ho.repeat(r.size.x - 2)}${br}')
}

fn (r Rectangle) get_box() Box {
	return Box{
		top: r.anchor.y
		right: r.anchor.x
		bottom: r.anchor.y + r.size.y
		left: r.anchor.x + r.size.x
	}
}

pub fn (r Rectangle) dispatch_event(event &ui.Event, mut target Drawable) {
	k := event.typ
	for el in r.event_listeners[k] {
		if el(event, mut target) {
			break
		}
	}
}

pub fn (r Rectangle) get_text_lines() []string {
	return chunk(r.text, r.size.x - 4)
}
