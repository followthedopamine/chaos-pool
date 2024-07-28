extends Area2D

@onready var cue_ball = $"../../CueBall"


func _on_body_entered(body):
	if body == cue_ball:
		cue_ball.reset()
	else:
		body.queue_free()
