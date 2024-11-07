extends RigidBody2D

func destroy_wall():
	queue_free()
	
func _on_body_entered(_body):
	await get_tree().create_timer(0.2).timeout
	destroy_wall()
