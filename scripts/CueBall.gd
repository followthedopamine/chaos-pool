extends RigidBody2D



const EXPLOSIVE_FORCE = 10
const EXPLOSION_SCALE = 10
const SUCK_MIN_DISTANCE = 30

var initial_position:Vector2
var has_exploded = false
var prev_frame_velocity


@onready var cue_ball_sprite = $CueBallSprite
@onready var level = $".."
@onready var cue_ball_type = level.cue_balls[0]
@onready var cue_ball_collision = $CueBallCollision
@onready var initial_collision_scale = cue_ball_collision.scale
@onready var cue_ball_area_of_effect = $CueBallAreaOfEffect


signal cue_ball_stopped

var cue_ball_active = false

func _ready():
	initial_position = global_position
	load_cue_ball()

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
			#Probably needs to be normalized
			
			ball.apply_central_impulse(Vector2(ball.global_position - global_position) * EXPLOSIVE_FORCE)
	
func load_infinite_ball_physics():
	linear_damp = 0
	linear_damp_mode = RigidBody2D.DAMP_MODE_REPLACE
	
func load_standard_ball_physics():
	linear_damp = 1.5
	linear_damp_mode = RigidBody2D.DAMP_MODE_COMBINE

func _on_collision(body):
	if body.is_in_group("balls"):
		#print(body)
		if body != self:
			if cue_ball_type == Global.CUE_BALL_TYPES.EXPLOSIVE:
				linear_velocity = Vector2.ZERO
				explode_ball()
				
func suck():
	#print("Is sucking")
	for ball:RigidBody2D in cue_ball_area_of_effect.get_overlapping_bodies():
		if ball != self:
			if abs(ball.global_position - global_position).length() > SUCK_MIN_DISTANCE:
				ball.apply_central_impulse(Vector2(global_position - ball.global_position))

func push():
	#print("Is sucking")
	for ball:RigidBody2D in cue_ball_area_of_effect.get_overlapping_bodies():
		if ball != self:
			ball.apply_central_impulse(Vector2(ball.global_position - global_position))

func trigger_constant_effects():
	#print("Is triggering constant effects")
	match cue_ball_type:
		Global.CUE_BALL_TYPES.WORMHOLE:
			suck()
		Global.CUE_BALL_TYPES.PUSHER:
			push()

func _on_balls_stopped():
	call_deferred("load_cue_ball")

func load_cue_ball():
	#await get_tree().create_timer(0.1).timeout #Necessary to make sure signal isn't recieved before ball is moving
	
	cue_ball_type = level.cue_balls[level.shot_counter]
	cue_ball_sprite.texture = Global.CUE_BALL_SPRITES[cue_ball_type]
	match cue_ball_type:
		Global.CUE_BALL_TYPES.STANDARD:
			load_standard_ball_physics()
		Global.CUE_BALL_TYPES.EXPLOSIVE:
			load_standard_ball_physics()
		Global.CUE_BALL_TYPES.WORMHOLE:
			load_standard_ball_physics()
		Global.CUE_BALL_TYPES.PUSHER:
			load_standard_ball_physics()
		Global.CUE_BALL_TYPES.INFINITE:
			load_infinite_ball_physics()
		
			
func trigger_cue_ball_end_effects():
	match cue_ball_type:
		Global.CUE_BALL_TYPES.EXPLOSIVE:
			explode_ball()
			
func check_cue_ball_still_moving():
	if level.cue_ball_active:
		#print(linear_velocity.length())
		if linear_velocity.length() <= Global.BALL_MOVING_THRESHHOLD:
			trigger_cue_ball_end_effects()
			print("Cue ball stopped moving")
			#await get_tree().create_timer(0.1).timeout #Necessary to make sure signal isn't recieved before ball is moving
			cue_ball_stopped.emit()

func _physics_process(_delta):
	#print(level.cue_ball_active)
	prev_frame_velocity = linear_velocity
	check_cue_ball_still_moving()
	
	if level.cue_ball_active:
		trigger_constant_effects()







