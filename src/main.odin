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
		g.WIN_WIDTH = 1920
		g.WIN_HEIGHT = 1080
		g.PLAYER = ent.create({0.0, 0.0})
		g.PLAYER.update = on_player_update
		//////////////////////////////////////////////////////////////////////////////////////////////////////

		//// INITIALIZE GAME /////////////////////////////////////////////////////////////////////////////////
		res := game.init()
		assert(res == true, "Failed to initialize game")
		defer game.deinit()
		game.g_mem.update = on_game_update
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


on_game_update :: proc() {
	game.render_entity(&game.g_mem.renderer, &g.PLAYER)
  g.PLAYER.update(&g.PLAYER)
}


on_player_update :: proc(entity: ^ent.Entity) {
	entity.transform.position.x += f32(io.KEY_STATE[sdl.Keycode.U] * 1)
	entity.transform.position.x += f32(io.KEY_STATE[sdl.Keycode.O] * (-1))
	entity.transform.position.y += f32(io.KEY_STATE[sdl.Keycode.PERIOD] * (-1))
	entity.transform.position.y += f32(io.KEY_STATE[sdl.Keycode.E] * (1))
}
