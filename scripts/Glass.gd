extends RigidBody2D

@onready var glass_animation_player = $GlassAnimationPlayer
@onready var glass_collision = $GlassCollision


func destroy_wall():
	queue_free()
	
	
func _on_body_entered(_body):
	set_deferred("glass_collision.disabled", true)
	#glass_collision.disabled = true
	glass_animation_player.play("shatter")
	await get_tree().create_timer(0.8).timeout
	destroy_wall()
