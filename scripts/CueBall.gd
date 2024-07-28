extends RigidBody2D

const EXPLOSIVE_FORCE = 40
const EXPLOSION_SCALE = 20

var initial_position:Vector2

var cue_ball_type = Global.CUE_BALL_TYPES.STANDARD

@onready var level = $".."
@onready var cue_ball_collision = $CueBallCollision

@onready var initial_collision_scale = cue_ball_collision.scale

func _ready():
	initial_position = global_position

func reset():
	linear_velocity = Vector2.ZERO
	await get_tree().create_timer(0.1).timeout
	global_position = initial_position
	# I have no explanation for why this doesn't work without a timer.
	# There will be an animation here so I don't think it matters.
	
func _on_body_entered(body):
	# We actually want the ball to explode on stopping movement too
	print(body)
	print(cue_ball_type)
	if body.is_in_group("balls"):
		body.apply_central_impulse(EXPLOSIVE_FORCE * (body.global_position - global_position))
		if cue_ball_type == Global.CUE_BALL_TYPES.EXPLOSIVE:
			cue_ball_collision.scale = initial_collision_scale * EXPLOSION_SCALE
			await get_tree().create_timer(0.3).timeout
			cue_ball_collision.scale = initial_collision_scale


func _on_balls_stopped():
	load_cue_ball()

func load_cue_ball():
	cue_ball_type = level.cue_balls[level.shot_counter]












