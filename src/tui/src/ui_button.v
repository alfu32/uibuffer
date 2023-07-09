module tui

import term.ui
import term

pub struct UiButton {
	widget_type string = 'ui-button'
mut:
	is_hovered          bool
	hovered_line_number i32
pub mut:
	status          string
	title           string
	event_listeners map[string][]EventListener = {
	}
	text   string
	anchor term.Coord = term.Coord{
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
		background: Color.blue.to_ui_color()
		color: Color.white.to_ui_color()
		border_set: BorderSets{}.single_solid
		weight: .normal
	}
	hover_style Style = Style{
		background: Color.blue.to_ui_color()
		color: Color.yellow.to_ui_color()
		border_set: BorderSets{}.single_solid
		weight: .bold
	}
}

pub fn (mut r UiButton) add_event_listener(t string, el EventListener) {
	r.event_listeners[t] << el
}

pub fn (r UiButton) draw(mut ctx ui.Context) {
	tx := r.text.trim_indent().trim(' ')
	tl, tr, bl, br, ho, ve := r.style.border_set.borders()
	if r.is_hovered {
		r.hover_style.apply_to_context(mut ctx)
	} else {
		r.style.apply_to_context(mut ctx)
	}
	ctx.draw_text(r.anchor.x, r.anchor.y, '${tl}${ho}${pad_right('', ho, r.size.x - 3)}${tr}')
	ctx.draw_text(r.anchor.x, r.anchor.y + 1, '${ve}${pad_center(tx, ' ', r.size.x - 2)}${ve}')
	ctx.draw_text(r.anchor.x, r.anchor.y + r.size.y - 1, '${bl}${pad_left(r.status, ho,
		r.size.x - 2)}${br}')
}

fn (r UiButton) get_box() Box {
	return Box{
		top: r.anchor.y
		left: r.anchor.x
		bottom: r.anchor.y + r.size.y
		right: r.anchor.x + r.size.x
	}
}

pub fn (r UiButton) dispatch_event(event &ui.Event, mut target Drawable) {
	k := '${event.typ}'
	for el in r.event_listeners[k] {
		if el(event, mut target) {
			break
		}
	}
}

pub fn (mut r UiButton) dispatch_event_by_name(event_name string, event &ui.Event, mut target Drawable) {
	for el in r.event_listeners[event_name] {
		if el(event, mut target) {
			break
		}
	}
}

pub fn (r UiButton) get_text_lines() []string {
	return chunk(r.text, r.size.x - 2)
}

pub fn (d UiButton) to_json() string {
	return to_json(d)
}
