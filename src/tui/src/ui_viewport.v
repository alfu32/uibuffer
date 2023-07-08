module tui

import term.ui
import term

pub struct UiViewport {
pub mut:
	log             []string
	status          string
	title           string
	event_listeners map[ui.EventType][]EventListener
	drawables       []Drawable
	ctx             &ui.Context
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

pub fn viewport_create() &UiViewport {
	w, h := term.get_terminal_size()
	mut vp := &UiViewport{
		log: []
		drawables: []
		event_listeners: {}
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
			vp.log << ('exiting')
			println(vp.log)
			exit(0)
		} else {
			vp.dispatch_event(e, mut vp)
		}
	}
	mut frame := fn [mut vp] (x voidptr) {
		vp.ctx.clear()
		vp.render()
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

pub fn (r UiViewport) get_text_lines() []string {
	return []
}

pub fn (mut r UiViewport) clear() {
	r.ctx.clear()
}

pub fn (mut r UiViewport) add(mut dw Drawable) {
	r.drawables << dw
}

pub fn (mut r UiViewport) add_event_listener(t ui.EventType, el EventListener) {
	r.event_listeners[t] << el
}

pub fn (r UiViewport) draw(mut ctx ui.Context) {
	r.style.apply_to_context(mut ctx)
	ctx.draw_text(r.anchor.x, r.anchor.y, '==${pad_right(r.title, '=', r.size.x - 3)}=')
	ctx.reset()
	for dw in r.drawables {
		dw.draw(mut ctx)
	}

	Style{
		background: Color.white.to_ui_color()
		color: Color.black.to_ui_color()
		border_set: BorderSets{}.single_solid
		weight: .normal
	}.apply_to_context(mut ctx)
	ctx.draw_text(0, r.size.y, r.status)
	ctx.reset()
}

pub fn (mut r UiViewport) render() {
	r.style.apply_to_context(mut r.ctx)
	r.ctx.draw_text(r.anchor.x, r.anchor.y, '==${pad_right(r.title, '=', r.size.x - 3)}=')
	for dw in r.drawables {
		dw.draw(mut r.ctx)
	}

	Style{
		background: Color.white.to_ui_color()
		color: Color.black.to_ui_color()
		border_set: BorderSets{}.single_solid
		weight: .normal
	}.apply_to_context(mut r.ctx)
	r.ctx.draw_text(0, r.size.y, r.status)
}

pub fn (mut r UiViewport) dispatch_event(e &ui.Event, mut target Drawable) {
	r.status = '
		x : ${e.x}, y : ${e.y}, typ : ${e.typ}, height : ${e.height}, width : ${e.width}, direction : ${e.direction}, code : ${e.code}
	'.trim_indent()
	/*.filter(fn [e] (dw Drawable) bool {
		return dw.get_box().contains(x: e.x, y: e.y)
	})*/
	for mut dw in r.drawables {
		dwbox := dw.get_box()
		is_in := dwbox.contains(x: e.x, y: e.y)
		// dw.status="(${e.x},${e.y}) in ${dwbox.to_string()} $is_in"
		if is_in {
			// r.log << ("$i dispatch ok ${e.x},${e.y}")
			dw.dispatch_event(e, mut &dw)
		} else {
			// r.log << ("$i dispatch not ok ${e.x},${e.y}")
		}
	}
}

fn (r UiViewport) get_box() Box {
	return Box{
		top: r.anchor.y
		right: r.anchor.x
		bottom: r.anchor.y + r.size.y
		left: r.anchor.x + r.size.x
	}
}
