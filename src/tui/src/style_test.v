module tui

import term.ui

pub fn test_color_create() {
	kv := 'key:value'.split(':')
	println('${kv[0]}   :   ${kv[1]}')
	println(ui.Color{1, 2, 3})
}
