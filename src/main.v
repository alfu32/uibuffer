module main

import time
import tui_renderer
import term

fn main_0() {
	println('Hello World!')

	mut buf := tui_renderer.init()
	dur := 500 * time.millisecond
	for _ in 1 .. 3 {
		buf.fill('+')
		time.sleep(dur)
		buf.fill_rect(10, 10, 10, 10, ' ')
		buf.stroke_rect(10, 10, 10, 10)
		buf.render()
		buf.clear()
		time.sleep(dur)
		buf.fill_rect(10, 10, 10, 10, '/')
		buf.stroke_rect(10, 10, 10, 10)
		buf.render()
		time.sleep(dur)
		buf.fill('/')
		buf.render()
		time.sleep(dur)
		buf.clear()
		buf.fill_rect(10, 10, 10, 10, '+')
		buf.stroke_rect(10, 10, 10, 10)
		buf.render()
	}
}

fn main() {
	w, h := term.get_terminal_size()
	mut vp := tui_renderer.Viewport{
		drawables: [
			tui_renderer.Rectangle{
				anchor: term.Coord{
					x: 10
					y: 10
				}
				size: term.Coord{
					x: 44
					y: 10
				}
				scroll: term.Coord{
					x: 0
					y: 0
				}
				style: tui_renderer.Style{
					background: .bright_blue
					color: .black
					border_set: tui_renderer.BorderSets{}.single_solid_rounded
					weight: .normal
				}
			},
		]
		size: term.Coord{
			x: w
			y: h
		}
	}
	term.clear()
	vp.draw()
	term.set_cursor_position(term.Coord{ x: 0, y: h - 1 })
}
