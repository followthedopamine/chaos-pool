extends RigidBody2D

func destroy_wall():
	queue_free()
	
func _on_body_entered(body):
	destroy_wall()
