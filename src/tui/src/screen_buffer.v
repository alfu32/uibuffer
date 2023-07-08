module tui

import term

pub struct ScreenBuffer {
pub mut:
	buffer []string
	width  i32
	height i32
	style  Style
}

pub fn init() ScreenBuffer {
	width, height := term.get_terminal_size()
	return init_slice(width, height)
}

pub fn init_slice(width i32, height i32) ScreenBuffer {
	mut sb := ScreenBuffer{
		width: width
		height: height
		style: Style{
			color: Color.white.to_ui_color()
			background: Color.black.to_ui_color()
			border_set: BorderSets{}.single_solid_rounded
		}
	}
	sb.fill(' ')
	return sb
}

pub fn (mut b ScreenBuffer) fill(s string) ScreenBuffer {
	b.buffer = []string{}
	for _ in i32(0) .. b.height {
		b.buffer << (s.repeat(b.width))
	}
	return b
}

pub fn (b ScreenBuffer) render() {
	term.set_cursor_position(term.Coord{
		x: 0
		y: -b.height
	})
	for line in b.buffer {
		println(line)
	}
}

pub fn (mut b ScreenBuffer) clear() {
	b.fill(' ')
}

pub fn (mut b ScreenBuffer) fill_rect(x i32, y i32, w i32, h i32, s string) {
	for l in y .. (y + h) {
		mut line := b.buffer[l]
		b.buffer[l] = '${line[0..x]}${s.repeat(w)}${line[(x + w)..]}'
	}
}

pub fn (mut b ScreenBuffer) stroke_rect(x i32, y i32, w i32, h i32) {
	tl, tr, bl, br, ho, ve := b.style.border_set.borders()
	for l in y .. (y + h) {
		mut line := b.buffer[l].runes()
		b.buffer[l] = '${line[0..x - 1].string()}${ve}${line[x + 1..x + w].string()}${ve}${line[(
			x + w + 1)..].string()}'
	}
	mut edge := b.buffer[y].runes()
	b.buffer[y] = '${edge[0..x - 1].string()}${tl}${ho.repeat(w - 1)}${tr}${edge[(x + w + 2)..].string()}'
	edge = b.buffer[y + h].runes()
	b.buffer[y + h] = '${edge[0..x - 1].string()}${bl}${ho.repeat(w - 1)}${br}${edge[(x + w + 2)..].string()}'
}
