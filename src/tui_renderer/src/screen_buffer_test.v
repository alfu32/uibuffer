module tui_renderer

import time

pub fn test_create() {
	mut buf := init_slice(88, 20)
	buf.fill('+')
	time.sleep(1000)
	buf.render()
	buf.clear()
	time.sleep(1000)
	buf.render()
	buf.fill('+')
	time.sleep(1000)
	buf.render()
}

pub fn test_border_set() {
	bs := BorderSets{}.single_dashed
	println(bs)
	tl, tr, bl, br, h, v := bs.borders()
	println('
		tl : ${tl}
		tr : ${tr}
		bl : ${bl}
		br : ${br}
		h  : ${h}
		v  : ${v}
	'.trim_indent())
}
