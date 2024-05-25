package Core

import sdl "vendor:sdl2"


@(private)
Renderer :: struct {
	ren: ^sdl.Renderer,
}


@(private)
create_renderer :: proc(window: ^Window, renderer: ^Renderer) -> bool {

	renderer.ren = sdl.CreateRenderer(
		window.win,
		-1,
		sdl.RENDERER_ACCELERATED | sdl.RENDERER_PRESENTVSYNC,
	)

	assert(renderer.ren != nil, "Failed to create SDL2 Renderer")
	return true
}

@(private)
destroy_renderer :: proc(renderer: ^Renderer) {
	sdl.DestroyRenderer(renderer.ren)
	renderer.ren = nil
}
