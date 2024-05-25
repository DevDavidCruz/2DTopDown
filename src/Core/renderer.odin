package Core

import ent "entities"
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


render_entity :: proc(renderer: ^Renderer, entity: ^ent.Entity) {
	rect: sdl.FRect
	rect.x = entity.transform.position.x
	rect.y = entity.transform.position.y
	rect.w = 16
	rect.h = 16

	sdl.SetRenderDrawColor(renderer.ren, 255, 0, 0, 255)
	sdl.RenderFillRectF(renderer.ren, &rect)
}
