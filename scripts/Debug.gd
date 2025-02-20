extends Node2D

const DEBUG_MODE = false



var dots = []

func draw_dot(position: Vector2) -> void:
	dots.append(position)

func _process(delta: float) -> void:
	queue_redraw()
		
func _draw():
	if DEBUG_MODE:
		for dot in dots:
			draw_circle(to_local(dot), 1, Color(1, 1, 0, 1))
