module tui

import term
import json
import walkingdevel.vxml

pub fn test_to_json() {
	mut r2 := UiButton{
		text: 'click me'
		anchor: term.Coord{
			x: 55
			y: 10
		}
		size: term.Coord{
			x: 22
			y: 3
		}
		style: Style{
			background: Color.blue.to_ui_color()
			color: Color.yellow.to_ui_color()
			border_set: BorderSets{}.single_solid_rounded
			weight: .normal
		}
	}
	println(r2.to_json())
}

pub fn test_coords_from_json() {
	js := json.encode(term.Coord{ x: 1, y: 2 })
	println(js)
	c := json.decode(term.Coord, js) or { panic(err) }
	println(c)
}

pub fn test_from_json() {
	mut r2 := from_json('
		{
			"widget_type":"ui-button",
			"is_hovered":false,
			"hovered_line_number":0,
			"style":{
				"background":{"r":0,"g":0,"b":255},
				"color":{"r":255,"g":255,"b":0},
				"border_set":"╭─╮│╰─╯",
				"weight":41319
			},
			"hover_style":{
				"background":{"r":0,"g":0,"b":255},
				"color":{"r":255,"g":255,"b":0},
				"border_set":"╭─╮│╰─╯",
				"weight":41320
			},
			"scroll":{"x":1,"y":2},
			"anchor":{"x":55,"y":10},
			"size":{"x":22,"y":3},
			"status":"",
			"title":"",
			"text":"click me"
		}
	')
	println(r2)
}

pub fn test_to_xml() {
	mut r2 := UiButton{
		text: 'click me'
		anchor: term.Coord{
			x: 55
			y: 10
		}
		size: term.Coord{
			x: 22
			y: 3
		}
		style: Style{
			background: Color.blue.to_ui_color()
			color: Color.yellow.to_ui_color()
			border_set: BorderSets{}.single_solid_rounded
			weight: .normal
		}
	}
	println(to_xml(r2))
}

pub fn test_from_xml() {
	s := '
		<ui-button
		  style="background:0000ff;color:ffff00;border_set:╭─╮│╰─╯;weight:normal"
		  hover-style="background:0000ff;color:bfbfbf;border_set:╭─╮│╰─╯;weight:bold"
		  anchor-x="55"
		  anchor-y="10"
		  size-x="22"
		  size-y="3"
		  status=""
		  title=""
		>click me</ui-button>
	'
	mut btn := from_xml(s)
	xml := vxml.parse(s)
	println(xml.children[0].attributes)
	println(btn)
}
