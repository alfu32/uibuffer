module tui_renderer

import time


pub fn test_create() {
	mut buf := init_slice(88,20)
	buf.fill("+")
	time.sleep(1000)
	buf.render()
	buf.clear()
	time.sleep(1000)
	buf.render()
	buf.fill("+")
	time.sleep(1000)
	buf.render()
}
