extends Node2D

var balls = []

func get_balls():
	balls = []
	for ball:RigidBody2D in get_tree().get_nodes_in_group("balls"):
		balls.append(ball)
		ball.body_entered.connect(_on_ball_collision)

func _on_ball_collision(body):
	print(body)
	if body.is_in_group("balls"):
		var motion = body.move_and_collide(Vector2.ZERO, true)
		if motion:
			print(motion.get_collider_velocity())
			print(motion.get_position())
			print(motion.get_collider().position)
			print(motion.get_normal())
			var impulse = motion.get_normal() * motion.get_collider_velocity()
			print(impulse)
