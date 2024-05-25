package main
import game "Core"
import ent "Core/entities"
import g "Core/globals"
import "Core/io"
import "core:fmt"
import "core:mem"
import sdl "vendor:sdl2"


main :: proc() {
	track: mem.Tracking_Allocator
	mem.tracking_allocator_init(&track, context.allocator)
	defer mem.tracking_allocator_destroy(&track)
	context.allocator = mem.tracking_allocator(&track)
	{
		//// SET GLOBALS FOR GAME SUCH AS ////////////////////////////////////////////////////////////////////
		/// GAME_TITLE = Game Title
		/// WIN_WIDTH = Window Width
		/// WIN_HEIGHT = Window Height
		g.GAME_TITLE = "2D Top Down"
		g.FPS = 240
		g.WIN_WIDTH = 1920
		g.WIN_HEIGHT = 1080
		g.PLAYER = ent.create({0.0, 0.0})
		g.PLAYER.update = on_player_update
		g.PLAYER.render = player_render
		//////////////////////////////////////////////////////////////////////////////////////////////////////

		//// INITIALIZE GAME /////////////////////////////////////////////////////////////////////////////////
		res := game.init()
		assert(res == true, "Failed to initialize game")
		defer game.deinit()
		game.g_mem.update = on_game_update
		game.g_mem.render = render
		//////////////////////////////////////////////////////////////////////////////////////////////////////

		game.start()
	}

	for _, leak in track.allocation_map {
		fmt.printf("%v leaked %m\n", leak.location, leak.size)
		fmt.printf("memory %m\n", leak.memory)
	}
	for bad_free in track.bad_free_array {
		fmt.printf("%v allocation %p was freed badly\n", bad_free.location, bad_free.memory)
	}
}


on_game_update :: proc(delta_time: f32) {
	g.PLAYER.update(&g.PLAYER, delta_time)
}


render :: proc() {
	game.render_entity(&game.g_mem.renderer, &g.PLAYER)
	g.PLAYER.render(&g.PLAYER)
}



//////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////
/// PLAYER SPECIFIC METHODS //////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////////////////////////////////////
// Update method for player
on_player_update :: proc(entity: ^ent.Entity, delta_time: f32) {
	speed: f32 = 250.0
	delta_speed := delta_time * speed
	entity.transform.position.x += f32(io.KEY_STATE[sdl.Keycode.U] * 1) * delta_speed
	entity.transform.position.x += f32(io.KEY_STATE[sdl.Keycode.O] * (-1)) * delta_speed
	entity.transform.position.y += f32(io.KEY_STATE[sdl.Keycode.PERIOD] * (-1)) * delta_speed
	entity.transform.position.y += f32(io.KEY_STATE[sdl.Keycode.E] * (1)) * delta_speed
}

// Render method for player
player_render :: proc(entity: ^ent.Entity) {
	rect: sdl.FRect
	rect.x = entity.transform.position.x
	rect.y = entity.transform.position.y
	rect.w = 16
	rect.h = 16
	sdl.SetRenderDrawColor(game.g_mem.renderer.ren, 255, 0, 0, 255)
	sdl.RenderFillRectF(game.g_mem.renderer.ren, &rect)

}
//////////////////////////////////////////////////////////////////////////////////////////////////////
