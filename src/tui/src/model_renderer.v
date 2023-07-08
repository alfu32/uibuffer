module tui

import term
import term.ui

pub struct EventTarget {
pub:
	event &ui.Event
pub mut:
	target &Drawable
}

pub type EventListener = fn (event &ui.Event, mut target Drawable) bool

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
	status string
	title string
	dispatch_event(event &ui.Event, mut target Drawable)
	add_event_listener(t ui.EventType, el EventListener)
}
