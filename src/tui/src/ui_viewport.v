module tui

import term.ui
import term

pub struct UiViewport {
mut:
	is_hovered          bool
	hovered_line_number i32
pub mut:
	widget_type     string = 'ui-viewport'
	log             []string
	status          string
	title           string
	text            string
	event_listeners map[string][]EventListener
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
	hover_style Style = Style{
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

pub fn (vp UiViewport) get_text_lines() []string {
	return []
}

pub fn (mut vp UiViewport) clear() {
	vp.ctx.clear()
}

pub fn (mut vp UiViewport) add(mut dw Drawable) {
	vp.drawables << dw
}

pub fn (mut vp UiViewport) add_event_listener(t string, el EventListener) {
	vp.event_listeners[t] << el
}

pub fn (vp UiViewport) draw(mut ctx ui.Context) {
	vp.style.apply_to_context(mut ctx)
	ctx.draw_text(vp.anchor.x, vp.anchor.y, '==${pad_right(vp.title, '=', vp.size.x - 3)}=')
	ctx.reset()
	for dw in vp.drawables {
		dw.draw(mut ctx)
	}

	Style{
		background: Color.white.to_ui_color()
		color: Color.black.to_ui_color()
		border_set: BorderSets{}.single_solid
		weight: .normal
	}.apply_to_context(mut ctx)
	ctx.draw_text(0, vp.size.y, vp.status)
	ctx.reset()
}

pub fn (mut vp UiViewport) render() {
	vp.style.apply_to_context(mut vp.ctx)
	vp.ctx.draw_text(vp.anchor.x, vp.anchor.y, '==${pad_right(vp.title, '=', vp.size.x - 3)}=')
	for dw in vp.drawables {
		dw.draw(mut vp.ctx)
	}

	Style{
		background: Color.white.to_ui_color()
		color: Color.black.to_ui_color()
		border_set: BorderSets{}.single_solid
		weight: .normal
	}.apply_to_context(mut vp.ctx)
	vp.ctx.draw_text(0, vp.size.y, vp.status)
}

pub fn (mut vp UiViewport) dispatch_event(e &ui.Event, mut target Drawable) {
	vp.status = '
		x : ${e.x}, y : ${e.y}, typ : ${e.typ}, height : ${e.height}, width : ${e.width}, direction : ${e.direction}, code : ${e.code}
	'.trim_indent()
	/*.filter(fn [e] (dw Drawable) bool {
		return dw.get_box().contains(x: e.x, y: e.y)
	})*/
	for mut dw in vp.drawables {
		dwbox := dw.get_box()
		is_in := dwbox.contains(x: e.x, y: e.y)
		// dw.status="(${e.x},${e.y}) in ${dwbox.to_string()} $is_in"
		if is_in {
			if !dw.is_hovered {
				dw.dispatch_event_by_name('mouse_in', e, mut &dw)
				dw.is_hovered = true
			}
			dw.dispatch_event(e, mut &dw)
		} else {
			if dw.is_hovered {
				dw.dispatch_event_by_name('mouse_out', e, mut &dw)
				dw.is_hovered = false
				dw.hovered_line_number = 0
			}
			// r.log << ("$i dispatch not ok ${e.x},${e.y}")
		}
	}
}

pub fn (mut vp UiViewport) dispatch_event_by_name(event_name string, event &ui.Event, mut target Drawable) {
	vp.dispatch_event(event, mut target)
}

fn (vp UiViewport) get_box() Box {
	return Box{
		top: vp.anchor.y
		right: vp.anchor.x
		bottom: vp.anchor.y + vp.size.y
		left: vp.anchor.x + vp.size.x
	}
}

pub fn (vp UiViewport) to_json() string {
	return to_json(vp)
}
