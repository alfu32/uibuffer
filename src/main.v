module main

import time
import tui
import term
import term.ui

fn main_0() {
	println('Hello World!')

	mut buf := tui.init()
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
	// w, h := term.get_terminal_size()
	mut vp := tui.viewport_create()
	mut r := tui.UiTextBox{
		title: 'Run to the hills'
		text: '
				White Man came across the sea
				He brought us pain and misery
				He killed our tribes, he killed our creed
				He took our game for his own need

				We fought him hard, we fought him well
				Out on the plains we gave him hell
				But many came, too much for Cree
				Oh, will we ever be set free?

				Riding through dust clouds and barren wastes
				Galloping hard on the plains
				Chasing the redskins back to their holes
				Fighting them at their own game
				Murder for freedom the stab in the back
				Women and children are cowards, attack

				Run to the hills
				Run for your lives
				Run to the hills
				Run for your lives
				'.trim_indent()
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
		style: tui.Style{
			background: tui.Color.bright_blue.to_ui_color()
			color: tui.Color.black.to_ui_color()
			border_set: tui.BorderSets{}.single_solid_rounded
			weight: .normal
		}
	}
	r.add_event_listener(.mouse_up, fn (event &ui.Event, mut target tui.Drawable) bool {
		target.status += '+'
		return false
	})
	mut b1 := tui.UiButton{
		status: ''
		title: ''
		event_listeners: {}
		text: 'hide'
		anchor: term.Coord{
			x: 5
			y: 2
		}
		size: term.Coord{
			x: 20
			y: 3
		}
		scroll: term.Coord{
			x: 0
			y: 0
		}
		style: tui.Style{
			background: tui.Color.green.to_ui_color()
			color: tui.Color.black.to_ui_color()
			border_set: tui.BorderSets{}.single_solid_rounded
			weight: .normal
		}
	}
	vp.add(r)
	vp.add(b1)
	vp.ctx.run()
}
