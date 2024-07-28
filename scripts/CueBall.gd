extends RigidBody2D

var initial_position:Vector2

func _ready():
	initial_position = global_position

func reset():
	linear_velocity = Vector2.ZERO
	await get_tree().create_timer(0.1).timeout
	global_position = initial_position
	# I have no explanation for why this doesn't work without a timer.
	# There will be an animation here so I don't think it matters.
