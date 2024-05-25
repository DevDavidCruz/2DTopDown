package peripherals
import sdl "vendor:sdl2"

KEY_STATE: [127]i32

handle_key_down :: proc(key_code: sdl.Keycode) {
	if cast(i32)key_code <= 127 {
		KEY_STATE[key_code] = 1
	}
}

handle_key_up :: proc(key_code: sdl.Keycode) {
	if cast(i32)key_code <= 127 {
		KEY_STATE[key_code] = 0
	}
}
