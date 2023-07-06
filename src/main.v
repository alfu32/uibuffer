module main

import time
import tui_renderer

fn main() {
	println('Hello World!')

	mut buf := tui_renderer.init()
	dur := 500 * time.millisecond
	for _ in 1 .. 3 {

		buf.fill("+")
		time.sleep(dur)
		buf.fill_rect(10,10,10,10," ")
		buf.stroke_rect(10,10,10,10)
		buf.render()
		buf.clear()
		time.sleep(dur)
		buf.fill_rect(10,10,10,10,"/")
		buf.stroke_rect(10,10,10,10)
		buf.render()
		buf.fill("/")
		time.sleep(dur)
		buf.fill_rect(10,10,10,10,"+")
		buf.stroke_rect(10,10,10,10)
		buf.render()
	}

}
