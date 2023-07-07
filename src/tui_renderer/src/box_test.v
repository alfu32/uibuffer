module tui_renderer

pub fn test_create() {
	bx := Box{
		top: 0
		left: 0
		bottom: 16
		right: 32
	}
	println(bx)
	assert bx.top == 0
	assert bx.left == 0
	assert bx.bottom == 16
	assert bx.right == 32
}

pub fn test_pad() {
	mut bx := Box{
		top: 0
		left: 0
		bottom: 16
		right: 32
	}
	bx = bx.pad(1)
	println(bx)
	assert bx.top == -1
	assert bx.left == -1
	assert bx.bottom == 17
	assert bx.right == 33
}

pub fn test_add_1() {
	mut bx1 := Box{
		top: 0
		left: 0
		bottom: 5
		right: 5
	}
	mut bx2 := Box{
		top: 6
		left: 6
		bottom: 10
		right: 10
	}
	bx3 := bx1.add(bx2)
	println(bx1)
	println(bx2)
	println(bx3)
	assert bx3.top == 0
	assert bx3.left == 0
	assert bx3.bottom == 10
	assert bx3.right == 10
}

pub fn test_add_2() {
	mut bx1 := Box{
		top: -5
		left: -5
		bottom: 3
		right: 3
	}
	mut bx2 := Box{
		top: 4
		left: 5
		bottom: 6
		right: 7
	}
	bx3 := bx1.add(bx2)
	println(bx1)
	println(bx2)
	println(bx3)
	assert bx3.top == -5
	assert bx3.left == -5
	assert bx3.bottom == 6
	assert bx3.right == 7
}

pub fn test_translate() {
	mut bx1 := Box{
		top: -5
		left: -5
		bottom: 3
		right: 3
	}
	mut bx2 := Box{
		top: 4
		left: 5
		bottom: 14
		right: 15
	}
	bx3 := bx2.translate(bx1)
	println(bx1)
	println(bx2)
	println(bx3)
	assert bx3.top == -1
	assert bx3.left == 0
	assert bx3.bottom == 9
	assert bx3.right == 10
}

pub fn test_contains() {
	bx := Box{
		top: 0
		left: 0
		bottom: 16
		right: 32
	}
	assert bx.contains(x: 10, y: 10)
	assert bx.top == 0
	assert bx.left == 0
	assert bx.bottom == 16
	assert bx.right == 32
}
