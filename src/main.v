module main

import time
import tui_renderer

fn main() {
	println('Hello World!')

	mut buf := tui_renderer.init(88,20)
	dur := 500 * time.millisecond
	for _ in 1 .. 10 {

		buf.fill("+")
		time.sleep(dur)
		buf.render()
		buf.clear()
		time.sleep(dur)
		buf.render()
		buf.fill("/")
		time.sleep(dur)
		buf.render()
	}

}
