module tui

import term.ui

pub fn test_color_create() {
	kv := 'key:value'.split(':')
	println('${kv[0]}   :   ${kv[1]}')
	println(ui.Color{1, 2, 3})
}

pub fn test_to_css() {
	style := Style{
		background: Color.blue.to_ui_color()
		color: Color.white.to_ui_color()
		border_set: BorderSets{}.single_solid
		weight: .normal
	}
	println(style.to_css())
}

pub fn test_from_css() {
	style := 'background:0000ff;color:bfbfbf;border_set:┌─┐│└─┘;weight:normal'
	println(from_css(style))
}
