module tui

import term.ui
import term
import math

pub struct UiTextBox {
mut:
	is_hovered          bool
	hovered_line_number i32
pub mut:
	is_loading      bool   = false
	widget_type     string = 'ui-textbox'
	status          string
	title           string
	event_listeners map[string][]EventListener = {
		'mouse_scroll': [
			fn (event &ui.Event, mut target Drawable) bool {
				txl := target.get_text_lines().len
				h := target.size.y - 2
				if event.direction == .up {
					target.scroll.y = (target.scroll.y + 1)
				} else if event.direction == .down {
					target.scroll.y -= 1
				}
				if target.scroll.y < 0 {
					target.scroll.y = 0
				}
				if target.scroll.y > (math.signi(txl - h + 1) * (txl - h + 1)) {
					target.scroll.y -= 1
				}
				return false
			},
		]
		'mouse_move':   [
			fn (event &ui.Event, mut target Drawable) bool {
				target.hovered_line_number = event.y - target.anchor.y
				return false
			},
		]
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
		background: Color.black.to_ui_color()
		color: Color.bright_black.to_ui_color()
		border_set: BorderSets{}.single_dotted
		weight: .normal
	}
	hover_style Style = Style{
		background: Color.bright_black.to_ui_color()
		color: Color.white.to_ui_color()
		border_set: BorderSets{}.single_solid_rounded
		weight: .normal
	}
}

pub fn (mut r UiTextBox) add_event_listener(t string, el EventListener) {
	r.event_listeners[t] << el
}

pub fn (r UiTextBox) draw(mut ctx ui.Context) {
	tx := r.get_text_lines()
	mut style := r.style
	mut tl, tr, bl, br, ho, ve := if r.is_hovered {
		style = r.hover_style
		r.hover_style.border_set.borders()
	} else {
		r.style.border_set.borders()
	}
	style.apply_to_context(mut ctx)
	scroller_pos := (r.scroll.y * r.size.y + 2) / (tx.len + 1)
	ctx.draw_text(r.anchor.x, r.anchor.y, '${tl}${ho}${pad_right('', ho, r.size.x - 3)}${tr}')
	ctx.bold()
	ctx.draw_text(r.anchor.x + 2, r.anchor.y, r.title)
	style.apply_to_context(mut ctx)
	for l in r.anchor.y + 1 .. r.anchor.y + r.size.y - 1 {
		txl := r.scroll.y + (l - r.anchor.y - 1)
		if (l - r.anchor.y - 1) >= scroller_pos - 1 && (l - r.anchor.y - 1) <= scroller_pos + 1 {
			ctx.draw_text(r.anchor.x, l, '${ve}${' '.repeat(r.size.x - 2)}┃')
		} else {
			ctx.draw_text(r.anchor.x, l, '${ve}${' '.repeat(r.size.x - 2)}${ve}')
		}

		if txl < tx.len {
			// ctx.draw_text(r.anchor.x + 1, l, pad_left(txl.str(), ' ', 2))
			ctx.draw_text(r.anchor.x + 1, l, tx[txl][0..r.size.x - 2])
		}
	}
	/// term.set_cursor_position(term.Coord{ x: r.anchor.x, y: r.anchor.y + r.size.y - 1 })
	ctx.draw_text(r.anchor.x, r.anchor.y + r.size.y - 1, '${bl}${pad_left(r.status, ho,
		r.size.x - 2)}${br}')
}

fn (r UiTextBox) get_box() Box {
	return Box{
		top: r.anchor.y
		left: r.anchor.x
		bottom: r.anchor.y + r.size.y
		right: r.anchor.x + r.size.x
	}
}

pub fn (r UiTextBox) dispatch_event(event &ui.Event, mut target Drawable) {
	k := '${event.typ}'
	for el in r.event_listeners[k] {
		if el(event, mut target) {
			break
		}
	}
}

pub fn (mut r UiTextBox) dispatch_event_by_name(event_name string, event &ui.Event, mut target Drawable) {
	for el in r.event_listeners[event_name] {
		if el(event, mut target) {
			break
		}
	}
}

pub fn (r UiTextBox) get_text_lines() []string {
	return chunk(r.text, r.size.x - 2)
}

pub fn (d UiTextBox) to_json() string {
	return to_json(d)
}
