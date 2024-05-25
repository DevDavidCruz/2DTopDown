package Core
import "core:fmt"
import "core:math"
import g "globals"
import "io"
import sdl "vendor:sdl2"


// global Game struct
g_mem: Game

@(private)
Game :: struct {
	window:   Window,
	renderer: Renderer,
	start:    proc() -> bool,
	update:   proc(delta_time: f32),
  render: proc()
}


// Initialize g_mem global struct
// creates window 
// creates renderer 
init :: proc() -> (success: bool) {
	success = true
	success = create_window(&g_mem.window, g.GAME_TITLE, g.WIN_WIDTH, g.WIN_HEIGHT)
	success = create_renderer(&g_mem.window, &g_mem.renderer)
	g_mem.start = start
	return success
}

deinit :: proc() {
	destroy_window(&g_mem.window)
	destroy_renderer(&g_mem.renderer)
}

/* Start the main Game loop
   Ensure that you set a proc for g_mem.update
   ex:
   import game "Core"
   main::proc(){
    game.init()
    defer (game.deinit())

    game.g_mem.update = on_game_update
    game.start()
   }
  on_game_update::proc(){ 
    fmt.println("Game Updated")
  }
*/
start :: proc() -> (success: bool) {
	FRAME_DELAY: u32 = 1000 / g.FPS

	success = true
	fmt.print("START")

	LAST_UPDATE: u32
	main_loop: for {
		FRAME_START := sdl.GetTicks()

		/// EVENTS LOOP  //////////////////////////////////////////////////////////////////////////
		event: sdl.Event
		for sdl.PollEvent(&event) != false {

			#partial switch event.type {
			case .KEYDOWN:
				io.handle_key_down(event.key.keysym.sym)
				#partial switch event.key.keysym.sym {
				case .ESCAPE:
					break main_loop
				}
			case .KEYUP:
				io.handle_key_up(event.key.keysym.sym)
			case .QUIT:
				break main_loop
			}
		}
		////////////////////////////////////////////////////////////////////////////////////////////


		/// PHYSICS LOOP  //////////////////////////////////////////////////////////////////////////
		CURRENT_TIME: u32 = sdl.GetTicks()
		DELTA_TIME: f32 = f32(CURRENT_TIME - LAST_UPDATE) / 1000.0
		g_mem.update(DELTA_TIME)
		LAST_UPDATE = CURRENT_TIME
		////////////////////////////////////////////////////////////////////////////////////////////

		/// RENDER LOOP  //////////////////////////////////////////////////////////////////////////
		sdl.SetRenderDrawColor(g_mem.renderer.ren, 0, 0, 0, 255)
		sdl.RenderClear(g_mem.renderer.ren)
    g_mem.render()
		sdl.RenderPresent(g_mem.renderer.ren)
		////////////////////////////////////////////////////////////////////////////////////////////

		FRAME_END := sdl.GetTicks()
		FRAME_TIME: f32 = f32(FRAME_END - FRAME_START) / 1000.0
		//FPS: f32 = 1.0 / FRAME_TIME

		if f32(FRAME_DELAY) > FRAME_TIME {
			sdl.Delay(FRAME_DELAY - u32(FRAME_TIME))
			delay_fps: f32 = (1.0 / f32(FRAME_DELAY)) * 1000.0
			fmt.println(delay_fps)
		}
	}

	return success
}

@(private)
update :: proc() -> (success: bool) {
	success = true

	return success
}
