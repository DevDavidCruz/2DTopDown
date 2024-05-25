package engine


v2f :: struct {
	x: f32,
	y: f32,
}

Transform :: struct {
	position: v2f,
	rotation: f64,
	velocity: v2f,
}
