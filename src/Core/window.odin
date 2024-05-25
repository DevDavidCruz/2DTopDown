package Core

import sdl "vendor:sdl2"

@(private)
Window :: struct {
	win:    ^sdl.Window,
	width:  i32,
	height: i32,
}


@(private)
create_window :: proc(win: ^Window, title: cstring, width, height: i32) -> bool {
	win.win = sdl.CreateWindow(
		title,
		sdl.WINDOWPOS_CENTERED,
		sdl.WINDOWPOS_CENTERED,
		width,
		height,
		sdl.WINDOW_RESIZABLE | sdl.WINDOW_BORDERLESS,
	)

	assert(win.win != nil, "Failed to create SDL2 Window")
	return true
}

@(private)
destroy_window :: proc(win: ^Window) {
	sdl.DestroyWindow(win.win)
	win.win = nil
}
