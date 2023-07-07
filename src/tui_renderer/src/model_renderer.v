module tui_renderer

import term

pub interface Drawable {
	style Style
	draw()
}

pub struct Viewport {
pub mut:
	drawables []Drawable
	scroll    term.Coord = term.Coord{
		x: 0
		y: 0
	}
	anchor    term.Coord = term.Coord{
		x: 0
		y: 0
	}
	size      term.Coord = term.Coord{
		x: 144
		y: 44
	}
	style     Style      = Style{
		background: .black
		color: .white
		border_set: BorderSets{}.single_solid
		weight: .normal
	}
}

pub fn (mut r Viewport) add(dw Drawable) {
	r.drawables << dw
}

pub fn (r Viewport) draw() {
	for dw in r.drawables {
		dw.draw()
	}
}

pub struct Rectangle {
pub mut:
	anchor term.Coord = term.Coord{
		x: 0
		y: 0
	}
	size   term.Coord = term.Coord{
		x: 4
		y: 4
	}
	scroll term.Coord = term.Coord{
		x: 0
		y: 0
	}
	style  Style      = Style{
		background: .black
		color: .white
		border_set: BorderSets{}.single_solid
		weight: .normal
	}
}

pub fn (r Rectangle) draw() {
	tl, tr, bl, br, ho, ve := r.style.border_set.borders()
	term.set_cursor_position(r.anchor)
	print(r.style.apply('${tl}${ho.repeat(r.size.x - 2)}${tr}'))
	for l in r.anchor.y + 1 .. r.anchor.y + r.size.y - 1 {
		term.set_cursor_position(term.Coord{ x: r.anchor.x, y: l })
		/// print(r.style.apply("$ve"))
		/// term.set_cursor_position(term.Coord{x:r.anchor.x+r.size.x-1,y:l})
		/// print(r.style.apply("$ve"))
		//
		print(r.style.apply('${ve}${' '.repeat(r.size.x - 2)}${ve}'))
	}
	term.set_cursor_position(term.Coord{ x: r.anchor.x, y: r.anchor.y + r.size.y - 1 })
	print(r.style.apply('${bl}${ho.repeat(r.size.x - 2)}${br}'))
}
