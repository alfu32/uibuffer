module tui

import term.ui
import term

pub struct UiButton {
pub mut:
	status          string
	title           string
	event_listeners map[ui.EventType][]EventListener
	text            string
	anchor          term.Coord = term.Coord{
		x: 0
		y: 0
	}
	size term.Coord = term.Coord{
		x: 20
		y: 3
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

pub fn (mut r UiButton) add_event_listener(t ui.EventType, el EventListener) {
	r.event_listeners[t] << el
}

pub fn (r UiButton) draw(mut ctx ui.Context) {
	tl, tr, bl, br, ho, ve := r.style.border_set.borders()
	width := r.size.x
	// mut status := '${scroller_pos.str()}/${tx.len} ${r.scroll.y}'
	r.style.apply_to_context(mut ctx)
	ctx.draw_text(r.anchor.x, r.anchor.y, '${tl}${ho}${pad_right('', ho, width - 3)}${tr}')
	l := r.anchor.y + 1
	ctx.draw_text(r.anchor.x, l, '${ve}${' '.repeat(width - 2)}${ve}')
	ctx.draw_text(r.anchor.x + 1, l, r.text[0..width - 2])
	ctx.draw_text(r.anchor.x, r.anchor.y + r.size.y - 1, '${bl}${ho.repeat(width - 2)}${br}')
}

fn (r UiButton) get_box() Box {
	return Box{
		top: r.anchor.y
		right: r.anchor.x
		bottom: r.anchor.y + r.size.y
		left: r.anchor.x + r.size.x
	}
}

pub fn (r UiButton) dispatch_event(event &ui.Event, mut target Drawable) {
	k := event.typ
	for el in r.event_listeners[k] {
		if el(event, mut target) {
			break
		}
	}
}

pub fn (r UiButton) get_text_lines() []string {
	return chunk(r.text, r.size.x - 2)
}
