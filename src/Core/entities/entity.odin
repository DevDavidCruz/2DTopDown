package entities
import eng "../engine"


Entity :: struct {
	using transform: eng.Transform,
	variant:         union {},
	update:          proc(entity: ^Entity, delta_time: f32),
}

create :: proc(pos: eng.v2f) -> Entity {
	return Entity{position = pos, rotation = 0, velocity = {0.0, 0.0}}
}
