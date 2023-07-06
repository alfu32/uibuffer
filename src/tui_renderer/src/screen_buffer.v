module tui_renderer

import term

pub struct ScreenBuffer{
	pub mut:
	buffer []string
	width i32
	height i32
}

pub fn init(width i32,height i32) ScreenBuffer {
	mut sb := ScreenBuffer{
		width : width
		height : height
	}
	sb.fill(' ')
	return sb
}
pub fn (mut b ScreenBuffer) fill(s string) ScreenBuffer {
	b.buffer = []string{}
	for _ in  i32(0)..b.height {
		b.buffer << (s.repeat(b.width))
	}
	return b
}

pub fn (b ScreenBuffer) render(){
	term.set_cursor_position(term.Coord{
		x: 0
		y: 0
	})
	for line in b.buffer {
		println(line)
	}
}
pub fn (mut b ScreenBuffer) clear(){
	b.fill(' ')
}
pub fn (mut b ScreenBuffer) fill_rect(x i32, y i32, w i32, h i32,s string){
	for l in y..(y+h) {
		mut line := b.buffer[l]
		b.buffer[l]="${line[0..x]}${s.repeat(w)}${line[(x+w)..]}"
	}
}
