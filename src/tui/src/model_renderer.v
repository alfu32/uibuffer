module tui

import term
import term.ui
import json
import walkingdevel.vxml
import strconv

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
	to_json() string
mut:
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

pub fn from_init(dinit DrawableInit) Drawable {
	match dinit.widget_type {
		'ui-button' {
			return UiButton{
				widget_type: dinit.widget_type
				is_hovered: dinit.is_hovered
				hovered_line_number: dinit.hovered_line_number
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
				is_hovered: dinit.is_hovered
				hovered_line_number: dinit.hovered_line_number
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

pub fn from_xml(s string) Drawable {
	doc := vxml.parse(s)
	node := doc.children[0]
	x := strconv.atoi(node.attributes['anchor-x']) or { 0 }
	y := strconv.atoi(node.attributes['anchor-y']) or { 0 }
	w := strconv.atoi(node.attributes['size-x']) or { 0 }
	h := strconv.atoi(node.attributes['size-y']) or { 0 }
	sx := strconv.atoi(node.attributes['scroll-x']) or { 0 }
	sy := strconv.atoi(node.attributes['scroll-y']) or { 0 }
	di := DrawableInit{
		widget_type: node.name
		status: node.attributes['status']
		title: node.attributes['title']
		text: node.attributes['text']
		anchor: term.Coord{
			x: x
			y: y
		}
		size: term.Coord{
			x: w
			y: h
		}
		scroll: term.Coord{
			x: sx
			y: sy
		}
		style: from_css(node.attributes['styles'])
		hover_style: from_css(node.attributes['hover-style'])
	}
	return from_init(di)
}
