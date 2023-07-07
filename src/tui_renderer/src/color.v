module tui_renderer

import term.ui

pub enum Color {
	black = 0x000000
	blue = 0x0000ff
	cyan = 0x00ffff
	green = 0x00ff00
	magenta = 0xff00ff
	red = 0xff0000
	white = 0xbfbfbf
	yellow = 0xffff00
	bright_black = 0x7f7f7f
	bright_blue = 0x7f7fff
	bright_cyan = 0x7fffff
	bright_green = 0x7fff7f
	bright_magenta = 0xff7fff
	bright_red = 0xff7f7f
	bright_white = 0xffffff
	bright_yellow = 0xffff7f
}

pub fn (c Color) to_ui_color() ui.Color {
	return to_color(u32(c))
}

pub fn to_color(u i32) ui.Color {
	return ui.Color{
		r: u8((u & 0xff0000) >> 16)
		g: u8((u & 0x00ff00) >> 8)
		b: u8(u & 0x0000ff)
	}
}
