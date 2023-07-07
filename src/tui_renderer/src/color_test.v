module tui_renderer

pub fn test_color_01() {
	col := to_color(0x102030)
	println(col)
	assert col.r == 16
	assert col.g == 32
	assert col.b == 48
}

pub fn test_color_02() {
	col := Color.bright_magenta.to_ui_color()
	println(col)
	assert col.r == 255
	assert col.g == 127
	assert col.b == 255
}

pub fn test_color_03() {
	println('bright_black : ${Color.bright_black.to_ui_color()}')
	println('bright_red : ${Color.bright_red.to_ui_color()}')
	println('bright_yellow : ${Color.bright_yellow.to_ui_color()}')
	println('bright_green : ${Color.bright_green.to_ui_color()}')
	println('bright_cyan : ${Color.bright_cyan.to_ui_color()}')
	println('bright_blue : ${Color.bright_blue.to_ui_color()}')
	println('bright_magenta : ${Color.bright_magenta.to_ui_color()}')
	println('bright_white : ${Color.bright_white.to_ui_color()}')

	println('black : ${Color.black.to_ui_color()}')
	println('red : ${Color.red.to_ui_color()}')
	println('yellow : ${Color.yellow.to_ui_color()}')
	println('green : ${Color.green.to_ui_color()}')
	println('cyan : ${Color.cyan.to_ui_color()}')
	println('blue : ${Color.blue.to_ui_color()}')
	println('magenta : ${Color.magenta.to_ui_color()}')
	println('white : ${Color.white.to_ui_color()}')
}
