module tui

import term
import term.ui
import json
import walkingdevel.vxml
import strconv

pub struct EventTarget {
pub:
	name  string
	event ui.Event
pub mut:
	target Ref[Drawable]
}

pub type EventListener = fn (event &ui.Event, mut target Drawable) bool

pub interface Drawable {
	draw(mut ctx ui.Context)
	get_box() Box
	get_text_lines() []string
	to_json() string
mut:
	is_loading bool
	widget_type string
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
	widget_type string
	style       Style
	hover_style Style
	scroll      term.Coord
	anchor      term.Coord
	size        term.Coord
	status      string
	title       string
	text        string
}

pub fn from_init(dinit DrawableInit) Drawable {
	match dinit.widget_type {
		'ui-button' {
			return UiButton{
				widget_type: dinit.widget_type
				status: dinit.status
				title: dinit.title
				text: dinit.text
				anchor: dinit.anchor
				size: dinit.size
				scroll: dinit.scroll
				style: dinit.style
				hover_style: dinit.hover_style
			}
		}
		else {
			return UiTextBox{
				widget_type: dinit.widget_type
				status: dinit.status
				title: dinit.title
				text: dinit.text
				anchor: dinit.anchor
				size: dinit.size
				scroll: dinit.scroll
				style: dinit.style
				hover_style: dinit.hover_style
			}
		}
	}
}

pub fn from_json(js string) Drawable {
	j := json.decode(DrawableInit, js) or { panic('invalid json ${err} in \n ${js}') }
	return from_init(j)
}

pub fn to_json(d Drawable) string {
	return json.encode(DrawableInit{
		widget_type: d.widget_type
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
		style="${d.style.to_css()}"
		hover-style="${d.hover_style.to_css()}"
		anchor-x="${d.anchor.x}"
		anchor-y="${d.anchor.y}"
		size-x="${d.size.x}"
		size-y="${d.size.y}"
		status="${d.status}"
		title="${d.title}"
		>${d.text}</${d.widget_type}>
	'.trim_indent()
}

pub fn from_xml(s string) &Drawable {
	doc := vxml.parse(s.trim_indent())
	node := doc.children[0]
	widget_type := node.name

	mut widget := match widget_type {
		'ui-button' {
			&Drawable(UiButton{})
		}
		else {
			&Drawable(UiTextBox{})
		}
	}
	for k, v in node.attributes {
		match k {
			'anchor-x' { widget.anchor.x = strconv.atoi(v) or { 0 } }
			'anchor-y' { widget.anchor.y = strconv.atoi(v) or { 0 } }
			'size-x' { widget.size.x = strconv.atoi(v) or { 0 } }
			'size-y' { widget.size.y = strconv.atoi(v) or { 0 } }
			'scroll-x' { widget.scroll.x = strconv.atoi(v) or { 0 } }
			'scroll-y' { widget.scroll.y = strconv.atoi(v) or { 0 } }
			'status' { widget.status = v }
			'title' { widget.title = v }
			'style' { widget.style = from_css(v) }
			'hover-style' { widget.hover_style = from_css(v) }
			else {}
		}
	}
	widget.text = node.text.trim_indent()
	return widget
}
