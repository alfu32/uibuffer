module tui_renderer

import term

pub enum Color {
	black = 0xC015
	blue
	cyan
	green
	magenta
	red
	white
	yellow
	bright_black
	bright_blue
	bright_cyan
	bright_green
	bright_magenta
	bright_red
	bright_white
	bright_yellow
}

pub enum Weight {
	normal = 0xA167
	bold
	strikethrough
	underlined
}

////////////    Box Drawing[1]
////////////    Official Unicode Consortium code chart (PDF)
////////////            0	1	2	3	4	5	6	7	8	9	A	B	C	D	E	F
////////////    U+250x	─	━	│	┃	┄	┅	┆	┇	┈	┉	┊	┋	┌	┍	┎	┏
////////////    U+251x	┐	┑	┒	┓	└	┕	┖	┗	┘	┙	┚	┛	├	┝	┞	┟
////////////    U+252x	┠	┡	┢	┣	┤	┥	┦	┧	┨	┩	┪	┫	┬	┭	┮	┯
////////////    U+253x	┰	┱	┲	┳	┴	┵	┶	┷	┸	┹	┺	┻	┼	┽	┾	┿
////////////    U+254x	╀	╁	╂	╃	╄	╅	╆	╇	╈	╉	╊	╋	╌	╍	╎	╏
////////////    U+255x	═	║	╒	╓	╔	╕	╖	╗	╘	╙	╚	╛	╜	╝	╞	╟
////////////    U+256x	╠	╡	╢	╣	╤	╥	╦	╧	╨	╩	╪	╫	╬	╭	╮	╯
////////////    U+257x	╰	╱	╲	╳	╴	╵	╶	╷	╸	╹	╺	╻	╼	╽	╾	╿
type BorderSet = string

pub struct BorderSets {
pub:
	ascii                 BorderSet = '+-+|+-+'
	single_solid          BorderSet = '┌─┐│└─┘'
	single_dotted         BorderSet = '┌┄┐┊└┄┘'
	single_dashed         BorderSet = '┌╴┐┆└╴┘'
	single_solid_rounded  BorderSet = '╭─╮│╰─╯'
	single_dotted_rounded BorderSet = '╭┄╮┊╰┄╯'
	single_dashed_rounded BorderSet = '╭╴╮┆╰╴╯'
}

pub fn (b BorderSet) borders() (string, string, string, string, string, string) {
	r := b.runes()
	return [r[0]].string(), [r[2]].string(), [r[4]].string(), [r[6]].string(), [r[1]].string(), [
		r[3],
	].string()
}

pub struct Style {
	background Color
	color      Color
	border_set BorderSet
	weight     Weight
}

pub fn (s Style) apply(text string) string {
	mut r := match s.background {
		.black { term.bg_black(text) }
		.blue { term.bg_blue(text) }
		.cyan { term.bg_cyan(text) }
		.green { term.bg_green(text) }
		.magenta { term.bg_magenta(text) }
		.red { term.bg_red(text) }
		.white { term.bg_white(text) }
		.yellow { term.bg_yellow(text) }
		.bright_black { term.bright_bg_black(text) }
		.bright_blue { term.bright_bg_blue(text) }
		.bright_cyan { term.bright_bg_cyan(text) }
		.bright_green { term.bright_bg_green(text) }
		.bright_magenta { term.bright_bg_magenta(text) }
		.bright_red { term.bright_bg_red(text) }
		.bright_white { term.bright_bg_white(text) }
		.bright_yellow { term.bright_bg_yellow(text) }
	}
	r = match s.color {
		.black { term.bg_black(r) }
		.blue { term.bg_blue(r) }
		.cyan { term.bg_cyan(r) }
		.green { term.bg_green(r) }
		.magenta { term.bg_magenta(r) }
		.red { term.bg_red(r) }
		.white { term.bg_white(r) }
		.yellow { term.bg_yellow(r) }
		.bright_black { term.bright_bg_black(r) }
		.bright_blue { term.bright_bg_blue(r) }
		.bright_cyan { term.bright_bg_cyan(r) }
		.bright_green { term.bright_bg_green(r) }
		.bright_magenta { term.bright_bg_magenta(r) }
		.bright_red { term.bright_bg_red(r) }
		.bright_white { term.bright_bg_white(r) }
		.bright_yellow { term.bright_bg_yellow(r) }
	}
	r = match s.weight {
		.normal { term.reset(r) }
		.bold { term.bold(r) }
		.strikethrough { term.strikethrough(r) }
		.underlined { term.underline(r) }
	}
	return r
}
