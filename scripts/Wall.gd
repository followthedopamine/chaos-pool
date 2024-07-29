extends StaticBody2D

func destroy_wall():
	queue_free()
	
func _on_cue_ball_body_entered(_body):
	destroy_wall()
