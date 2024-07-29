extends RigidBody2D

const STANDARD_PLACEHOLDER = preload("res://images/placeholder/cue-ball-placeholder.png")
const EXPLOSIVE_PLACEHOLDER = preload("res://images/placeholder/explosive-placeholder.png")
const INFINITE_PLACEHOLDER = preload("res://images/placeholder/infinite-placeholder.png")

const CUE_BALL_SPRITES = [STANDARD_PLACEHOLDER, EXPLOSIVE_PLACEHOLDER, 0, 0, INFINITE_PLACEHOLDER]

const EXPLOSIVE_FORCE = 60
const EXPLOSION_SCALE = 10

var initial_position:Vector2
var has_exploded = false

var cue_ball_type = Global.CUE_BALL_TYPES.STANDARD
@onready var cue_ball_sprite = $CueBallSprite


@onready var level = $".."
@onready var cue_ball_collision = $CueBallCollision

@onready var initial_collision_scale = cue_ball_collision.scale

@onready var cue_ball_area_of_effect = $CueBallAreaOfEffect


signal cue_ball_stopped

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
	for ball:RigidBody2D in cue_ball_area_of_effect.get_overlapping_bodies():
		if ball != self:
			ball.apply_central_impulse(Vector2(ball.global_position - global_position) * EXPLOSIVE_FORCE)
	
	
func load_infinite_ball_physics():
	linear_damp = 0
	linear_damp_mode = RigidBody2D.DAMP_MODE_REPLACE
	
func load_standard_ball_physics():
	linear_damp = 1.5
	linear_damp_mode = RigidBody2D.DAMP_MODE_COMBINE

func _on_body_entered(body):
	if body.is_in_group("balls"):
		print(body)
		if body != self:
			linear_velocity = Vector2.ZERO
			if cue_ball_type == Global.CUE_BALL_TYPES.EXPLOSIVE:
				explode_ball()

func _on_balls_stopped():
	load_cue_ball()

func load_cue_ball():
	cue_ball_type = level.cue_balls[level.shot_counter]
	cue_ball_sprite.texture = CUE_BALL_SPRITES[cue_ball_type]
	match cue_ball_type:
		Global.CUE_BALL_TYPES.STANDARD:
			load_standard_ball_physics()
		Global.CUE_BALL_TYPES.EXPLOSIVE:
			load_standard_ball_physics()
		Global.CUE_BALL_TYPES.INFINITE:
			load_infinite_ball_physics()
		
			
func trigger_cue_ball_effects():
	match cue_ball_type:
		Global.CUE_BALL_TYPES.EXPLOSIVE:
			explode_ball()
			
func check_cue_ball_moving():
	if level.cue_ball_active:
		if linear_velocity.length() <= Global.BALL_MOVING_THRESHHOLD:
			trigger_cue_ball_effects()
			print("Cue ball stopped moving")
			cue_ball_stopped.emit()

func _physics_process(_delta):
	check_cue_ball_moving()



