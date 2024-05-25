package Core
import g "globals"
import sdl "vendor:sdl2"


// global Game struct
g_mem: Game

@(private)
Game :: struct {
	window:   Window,
	renderer: Renderer,
	start:    proc() -> bool,
	update:   proc(),
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
	success = true

	main_loop: for {
		event: sdl.Event

		sdl.SetRenderDrawColor(g_mem.renderer.ren, 0, 0, 0, 255)
		sdl.RenderClear(g_mem.renderer.ren)

		for sdl.PollEvent(&event) != false {

			#partial switch event.type {
			case .KEYDOWN:
				#partial switch event.key.keysym.sym {
				case .ESCAPE:
					break main_loop
				case .u:
					g.PLAYER.transform.position.x += 1
				case .o:
					g.PLAYER.transform.position.x -= 1
				case .PERIOD:
					g.PLAYER.transform.position.y -= 1
				case .e:
					g.PLAYER.transform.position.y += 1
				}
			case .QUIT:
				break main_loop
			}
		}

		g_mem.update()

		sdl.RenderPresent(g_mem.renderer.ren)
	}

	return success
}

@(private)
update :: proc() -> (success: bool) {
	success = true

	return success
}
