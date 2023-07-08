module tui

import math
import term

pub struct Box {
pub mut:
	top    i32
	left   i32
	bottom i32
	right  i32
}

fn (b Box) add(box Box) Box {
	return Box{
		top: math.min(b.top, box.top)
		left: math.min(b.left, box.left)
		bottom: math.max(b.bottom, box.bottom)
		right: math.max(b.right, box.right)
	}
}

fn (b Box) translate(box Box) Box {
	return Box{
		top: b.top + box.top
		left: b.left + box.left
		bottom: b.bottom + box.top
		right: b.right + box.left
	}
}

fn (b Box) pad(padding i32) Box {
	return Box{
		top: math.min(b.top - padding, b.bottom + padding)
		left: math.min(b.right + padding, b.left - padding)
		bottom: math.max(b.top - padding, b.bottom + padding)
		right: math.max(b.right + padding, b.left - padding)
	}
}

fn (b Box) contains(p term.Coord) bool {
	return (b.left <= p.x && b.right >= p.x) && (b.top <= p.y && b.bottom >= p.y)
}

fn (b Box) to_string() string {
	return '(${b.left},${b.top}),(${b.right},${b.bottom})'
}
