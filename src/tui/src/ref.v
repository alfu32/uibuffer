module tui

[heap]
pub struct Ref[T] {
	ref &T
}

pub fn ref[T](t &T) &Ref[T] {
	return &Ref[T]{
		ref: t
	}
}

pub fn (r Ref[T]) unbox[T]() &T {
	return r.ref
}
