module tui

import term
import x.json2
import json

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

pub fn test_coords_from_json2() {
	js := json2.encode[term.Coord](term.Coord{ x: 1, y: 2 })
	println(js)
	c := json2.decode[term.Coord](js) or { panic(err) }
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

pub fn test_from_json2() {
	mut r2 := from_json2('
		{
			"widget_type":"ui-button",
			"is_hovered":false,
			"hovered_line_number":0,
			"style":{
				"background":{"r":0,"g":0,"b":255},
				"color":{"r":255,"g":255,"b":0},
				"border_set":"\u256d\u2500\u256e\u2502\u2570\u2500\u256f",
				"weight":41319
			},
			"hover_style":{
				"background":{"r":0,"g":0,"b":255},
				"color":{"r":255,"g":255,"b":0},
				"border_set":"\u250c\u2500\u2510\u2502\u2514\u2500\u2518",
				"weight":41320
			},
			"scroll":{"x":1,"y":2},
			"anchor":{"x":55,"y":10},
			"size":{"x":22,"y":3},
			"status":"",
			"title":"",
			"text":"click me"
		}
	') or {
		panic(err)
	}
	println(r2)
}
