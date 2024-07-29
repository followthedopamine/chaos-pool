extends RigidBody2D

const STANDARD_PLACEHOLDER = preload("res://images/placeholder/cue-ball-placeholder.png")
const EXPLOSIVE_PLACEHOLDER = preload("res://images/placeholder/explosive-placeholder.png")
const INFINITE_PLACEHOLDER = preload("res://images/placeholder/infinite-placeholder.png")

const CUE_BALL_SPRITES = [STANDARD_PLACEHOLDER, EXPLOSIVE_PLACEHOLDER, 0, 0, INFINITE_PLACEHOLDER]

const EXPLOSIVE_FORCE = 3
const EXPLOSION_SCALE = 10

var initial_position:Vector2
var has_exploded = false

var cue_ball_type = Global.CUE_BALL_TYPES.STANDARD
@onready var cue_ball_sprite = $CueBallSprite


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

func explode_ball():
	has_exploded = true
	cue_ball_collision.scale = initial_collision_scale * EXPLOSION_SCALE
	await get_tree().create_timer(0.3).timeout
	cue_ball_collision.scale = initial_collision_scale
	
func load_infinite_ball():
	linear_damp = 0
	linear_damp_mode = RigidBody2D.DAMP_MODE_REPLACE
	
func load_standard_ball():
	linear_damp = 1.5
	linear_damp_mode = RigidBody2D.DAMP_MODE_COMBINE

func _on_body_entered(body):
	# We actually want the ball to explode on stopping movement too
	print(body)
	print(cue_ball_type)
	if body.is_in_group("balls"):
		linear_velocity = Vector2.ZERO
		body.apply_central_impulse(EXPLOSIVE_FORCE * (body.global_position - global_position))
		if cue_ball_type == Global.CUE_BALL_TYPES.EXPLOSIVE:
			explode_ball()

func _on_balls_stopped():
	load_cue_ball()

func load_cue_ball():
	cue_ball_type = level.cue_balls[level.shot_counter]
	cue_ball_sprite.texture = CUE_BALL_SPRITES[cue_ball_type]
	match cue_ball_type:
		Global.CUE_BALL_TYPES.INFINITE:
			load_infinite_ball()






