module tui

import term
import term.ui
import json

pub struct EventTarget {
pub:
	event &ui.Event
pub mut:
	target &Drawable
}

pub type EventListener = fn (event &ui.Event, mut target Drawable) bool

pub interface Drawable {
	widget_type string
	draw(mut ctx ui.Context)
	get_box() Box
	get_text_lines() []string
	to_json() string
mut:
	is_hovered bool
	hovered_line_number i32
	style Style
	hover_style Style
	scroll term.Coord
	anchor term.Coord
	size term.Coord
	event_listeners map[string][]EventListener
	status string
	title string
	text string
	dispatch_event(event &ui.Event, mut target Drawable)
	dispatch_event_by_name(event_name string, event &ui.Event, mut target Drawable)
	add_event_listener(t string, el EventListener)
}

pub struct DrawableInit {
mut:
	widget_type         string
	is_hovered          bool
	hovered_line_number i32
	style               Style
	hover_style         Style
	scroll              term.Coord
	anchor              term.Coord
	size                term.Coord
	status              string
	title               string
	text                string
}

pub fn from_json(js string) Drawable {
	j := json.decode(DrawableInit, js) or { panic('invalid json ${err} in \n ${js}') }
	match j.widget_type {
		'ui-button' {
			return UiButton{
				widget_type: j.widget_type
				is_hovered: j.is_hovered
				hovered_line_number: j.hovered_line_number
				status: j.status
				title: j.title
				text: j.text
				anchor: j.anchor
				size: j.size
				scroll: j.scroll
				style: j.style
				hover_style: j.hover_style
			}
		}
		else {
			return UiTextBox{
				widget_type: j.widget_type
				is_hovered: j.is_hovered
				hovered_line_number: j.hovered_line_number
				status: j.status
				title: j.title
				text: j.text
				anchor: j.anchor
				size: j.size
				scroll: j.scroll
				style: j.style
				hover_style: j.hover_style
			}
		}
	}
}

pub fn to_json(d Drawable) string {
	return json.encode(DrawableInit{
		widget_type: d.widget_type
		is_hovered: d.is_hovered
		hovered_line_number: d.hovered_line_number
		style: d.style
		hover_style: d.hover_style
		scroll: d.scroll
		anchor: d.anchor
		size: d.size
		status: d.status
		title: d.title
		text: d.text
	})
}

pub fn to_xml(d Drawable) string {
	return '
		<${d.widget_type}
		style="${d.style}"
		hover_style="${d.hover_style}"
		anchor="${d.anchor}"
		size="${d.size}"
		status="${d.status}"
		title="${d.title}"
		>${d.text}</${d.widget_type}>
	'.trim_indent()
}
