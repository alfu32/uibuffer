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
	}
	mut r2 := tui.UiButton{
		title: ''
		text: 'click me'
		anchor: term.Coord{
			x: 55
			y: 10
		}
		size: term.Coord{
			x: 22
			y: 3
		}
	}
	r2.add_event_listener('mouse_up', fn (event &ui.Event, mut target tui.Drawable) bool {
		target.status += '+'
		return false
	})
	mut r3 := tui.UiButton{
		title: ''
		text: 'exit'
		anchor: term.Coord{
			x: 55
			y: 13
		}
		size: term.Coord{
			x: 22
			y: 3
		}
		style: tui.Style{
			background: tui.Color.red.to_ui_color()
			color: tui.Color.white.to_ui_color()
			border_set: tui.BorderSets{}.single_solid
			weight: .normal
		}
		hover_style: tui.Style{
			background: tui.Color.red.to_ui_color()
			color: tui.Color.yellow.to_ui_color()
			border_set: tui.BorderSets{}.single_solid
			weight: .bold
		}
	}
	r3.add_event_listener('mouse_up', fn (event &ui.Event, mut target tui.Drawable) bool {
		exit(0)
		return false
	})
	vp.add(mut r)
	vp.add(mut r2)
	vp.add(mut r3)
	// vp.add(mut b1)
	vp.ctx.run()
}
