module tui_renderer

pub fn test_chunk_string() {
	str := "
	What is Lorem Ipsum?
	Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.
	It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.
	It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.
	".trim_indent()

	chk := chunk(str, 32)
	println(chk)

	assert chk == [
		'What is Lorem Ipsum?            ',
		'Lorem Ipsum is simply dummy text',
		' of the printing and typesetting',
		' industry. Lorem Ipsum has been ',
		"the industry's standard dummy te",
		'xt ever since the 1500s, when an',
		' unknown printer took a galley o',
		'f type and scrambled it to make ',
		'a type specimen book.           ',
		'It has survived not only five ce',
		'nturies, but also the leap into ',
		'electronic typesetting, remainin',
		'g essentially unchanged.        ',
		'It was popularised in the 1960s ',
		'with the release of Letraset she',
		'ets containing Lorem Ipsum passa',
		'ges, and more recently with desk',
		'top publishing software like Ald',
		'us PageMaker including versions ',
		'of Lorem Ipsum.                 ',
	]
}

pub fn test_pad_left() {
	tx := '1234567890'
	println(pad_left(tx, '-', 20))
	println(pad_right(tx, '-', 20))
	println(pad_left(tx, '-', 5))
	println(pad_right(tx, '-', 5))
	println(pad_left(tx, '-', 11))
	println(pad_right(tx, '-', 11))
}
