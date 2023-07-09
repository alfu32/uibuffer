module tui

import regex
import arrays

pub fn pad_left(str string, chr string, n i32) string {
	return if str.len >= n {
		str
	} else {
		'${chr.repeat(n - str.len)}${str}'
	}
}

pub fn pad_center(str string, chr string, n i32) string {
	return if str.len >= n {
		str
	} else {
		pr := (n - str.len) / 2
		pl := n - str.len - (n - str.len) / 2
		'${chr.repeat(pl)}${str}${chr.repeat(pr)}'
	}
}

pub fn pad_right(str string, chr string, n i32) string {
	return if str.len >= n {
		str
	} else {
		'${str}${chr.repeat(n - str.len)}'
	}
}

pub fn chunk(tx string, chsz i32) []string {
	mut re, _, _ := regex.regex_base('.{1,${chsz}}')
	mut rows := tx.split('\n')
	rows = arrays.flat_map[string, string](rows, fn [mut re] (row string) []string {
		return re.find_all_str(row)
	})
	rows = rows.map(fn [chsz] (r string) string {
		return pad_right(r, ' ', chsz)
	})
	return rows
}
