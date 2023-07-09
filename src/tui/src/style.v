module tui

import term
import term.ui
import strconv

pub enum TextWeight {
	normal = 0xA167
	bold
	strikethrough
	underlined
}

pub enum Visibility {
	hidden = 0x12d6060
	collapsed
	visible
}

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
	background ui.Color
	color      ui.Color
	border_set BorderSet
	weight     TextWeight
}

pub fn color_from_string(s string) ui.Color {
	c := s.split(',')
	return ui.Color{
		r: u8(strconv.atoi(c[0]))
		g: u8(strconv.atoi(c[1]))
		b: u8(strconv.atoi(c[2]))
	}
}

pub fn from_css(css string) Style {
	mut background := ui.Color{}
	mut color := ui.Color{}
	mut border_set := ''
	mut weight := .normal
	for it in css.split(';') {
		kv := it.split(':')
		match kv[0] {
			'background' { background = color_from_string(kv[1]) }
			'color' { color = color_from_string(kv[1]) }
			'border_set' { border_set = kv[1] }
			'weight' { weight = TextWeight(kv[1]) }
			else {}
		}
	}
	mut s := Style{
		background: background
		color: color
		border_set: border_set
		weight: weight
	}
	return s
	// "background:${s.background};color:${s.color};border_set:${s.border_set};weight:${s.weight}"
}

pub fn (s Style) apply_to_context(mut ctx ui.Context) {
	match s.weight {
		.normal { ctx.reset() }
		.bold { ctx.bold() }
		.strikethrough { ctx.reset() }
		.underlined { ctx.reset() }
	}
	ctx.set_bg_color(s.background)
	ctx.set_color(s.color)
}

pub fn (s Style) apply_to_text(text string) string {
	mut r := match s.background.hex().parse_int(16, 8) or { 0 } {
		0x000000 { term.bg_black(text) }
		0x0000ff { term.bg_blue(text) }
		0x00ffff { term.bg_cyan(text) }
		0x00ff00 { term.bg_green(text) }
		0xff00ff { term.bg_magenta(text) }
		0xff0000 { term.bg_red(text) }
		0xbfbfbf { term.bg_white(text) }
		0xffff00 { term.bg_yellow(text) }
		0x7f7f7f { term.bright_bg_black(text) }
		0x7f7fff { term.bright_bg_blue(text) }
		0x7fffff { term.bright_bg_cyan(text) }
		0x7fff7f { term.bright_bg_green(text) }
		0xff7fff { term.bright_bg_magenta(text) }
		0xff7f7f { term.bright_bg_red(text) }
		0xffffff { term.bright_bg_white(text) }
		0xffff7f { term.bright_bg_yellow(text) }
		else { term.bright_bg_yellow(text) }
	}
	r = match s.color.hex().parse_int(16, 8) or { 0 } {
		0x000000 { term.bg_black(r) }
		0x0000ff { term.bg_blue(r) }
		0x00ffff { term.bg_cyan(r) }
		0x00ff00 { term.bg_green(r) }
		0xff00ff { term.bg_magenta(r) }
		0xff0000 { term.bg_red(r) }
		0xbfbfbf { term.bg_white(r) }
		0xffff00 { term.bg_yellow(r) }
		0x7f7f7f { term.bright_bg_black(r) }
		0x7f7fff { term.bright_bg_blue(r) }
		0x7fffff { term.bright_bg_cyan(r) }
		0x7fff7f { term.bright_bg_green(r) }
		0xff7fff { term.bright_bg_magenta(r) }
		0xff7f7f { term.bright_bg_red(r) }
		0xffffff { term.bright_bg_white(r) }
		0xffff7f { term.bright_bg_yellow(r) }
		else { term.bright_bg_yellow(text) }
	}
	r = match s.weight {
		.normal { term.reset(r) }
		.bold { term.bold(r) }
		.strikethrough { term.strikethrough(r) }
		.underlined { term.underline(r) }
	}
	return r
}

pub fn (s Style) to_css() string {
	return 'background:${s.background};color:${s.color};border_set:${s.border_set};weight:${s.weight}'
}
