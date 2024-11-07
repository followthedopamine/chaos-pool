extends RigidBody2D



const EXPLOSIVE_FORCE = 10
const EXPLOSION_SCALE = 10
const SUCK_MIN_DISTANCE = 30
const EXPLOSION_ANIMATION_DURATION = 0.4

var initial_position:Vector2
var has_exploded = false
var prev_frame_velocity
var frames_below_threshold := 0

var is_sinking = false

var needs_respawn = false


@onready var cue_ball_sprite = $CueBallMask/CueBallSprite
@onready var explosion_sprite = $ExplosionSprite
@onready var level = $".."
@onready var cue_ball_type = level.cue_balls[0]
@onready var cue_ball_collision = $CueBallCollision
@onready var initial_collision_scale = cue_ball_collision.scale
@onready var cue_ball_area_of_effect = $CueBallAreaOfEffect
@onready var cue_ball_animations = $CueBallAnimations
@onready var wormhole_animated_sprite = $WormholeAnimatedSprite
@onready var pusher_animated_sprite = $PusherAnimatedSprite

@onready var initial_alpha = modulate.a



func _ready():
	level.balls_stopped.connect(_on_balls_stopped)
	initial_position = global_position
	load_cue_ball()

func respawn_cue_ball():
	print("Respawning cue ball")
	linear_velocity = Vector2.ZERO
	global_position = initial_position
	needs_respawn = false 

func hide_ball():
	explosion_sprite.visible = false
	
func disable_collision():
	cue_ball_collision.disabled = true

func explode_ball():
	has_exploded = true
	explosion_sprite.visible = true
	cue_ball_sprite.visible = false
	cue_ball_animations.play("explosion")
	Sound.explosion(self)
	call_deferred("disable_collision")
	for ball:RigidBody2D in cue_ball_area_of_effect.get_overlapping_bodies():
		if ball != self:
			#Probably needs to be normalized
			#print(ball.name)
			ball.apply_central_impulse(Vector2(ball.global_position - global_position) * EXPLOSIVE_FORCE)
	

func load_infinite_ball_physics():
	linear_damp = 0
	linear_damp_mode = RigidBody2D.DAMP_MODE_REPLACE
	
func load_standard_ball_physics():
	linear_damp = 1.5
	linear_damp_mode = RigidBody2D.DAMP_MODE_COMBINE

func _on_collision(body):
	Sound.ball_collision_sound(prev_frame_velocity, body)
		
	if body.is_in_group("balls"):
		#print(body)
		if body != self:
			if cue_ball_type == Global.CUE_BALL_TYPES.EXPLOSIVE:
				linear_velocity = Vector2.ZERO
				explode_ball()
				
func suck():
	#print("Is sucking")
	if !wormhole_animated_sprite.visible:
		Sound.suck(self)
		wormhole_animated_sprite.visible = true
	for ball:RigidBody2D in cue_ball_area_of_effect.get_overlapping_bodies():
		if ball != self:
			if abs(ball.global_position - global_position).length() > SUCK_MIN_DISTANCE:
				ball.apply_central_impulse(Vector2(global_position - ball.global_position))

func push():
	#print("Is sucking")
	if !pusher_animated_sprite.visible:
		pusher_animated_sprite.visible = true
		Sound.push(self)
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
	
func reset_cue_ball():
	if needs_respawn:
		respawn_cue_ball()
	freeze = false
	frames_below_threshold = 0
	cue_ball_sprite.hframes = 1
	cue_ball_sprite.vframes = 1
	cue_ball_sprite.frame = 0
	cue_ball_sprite.scale = Vector2.ONE
	modulate.a = initial_alpha
	angular_velocity = 0
	load_standard_ball_physics()
	cue_ball_sprite.visible = true
	cue_ball_collision.disabled = false
	wormhole_animated_sprite.visible = false
	pusher_animated_sprite.visible = false
	Sound.end_all_loops()

func load_cue_ball():
	print("New cue ball loaded")
	reset_cue_ball()
	cue_ball_type = level.cue_balls[level.shot_counter]
	cue_ball_sprite.texture = Global.CUE_BALL_SPRITES[cue_ball_type]
	
	print("Cue ball type: " + str(cue_ball_type))
	match cue_ball_type:
		Global.CUE_BALL_TYPES.INFINITE:
			load_infinite_ball_physics()
		
			
func trigger_cue_ball_end_effects():
	match cue_ball_type:
		Global.CUE_BALL_TYPES.EXPLOSIVE:
			explode_ball()
			
func check_cue_ball_still_moving():
	# Needs to check if cue ball is not moving for 2 frames because
	# ball might be moving very slowly frame 1 and speed up frame 2
	if linear_velocity.length() <= Global.BALL_MOVING_THRESHHOLD:
		frames_below_threshold += 1
		#print(frames_below_threshold)
		if frames_below_threshold >= 2:
			trigger_cue_ball_end_effects()
			level.cue_ball_active = false
	else:
		frames_below_threshold = 0
			
func _on_balls_stopped():
	#load_cue_ball()
	pass
			
func _physics_process(_delta):
	#print(level.cue_ball_active)
	prev_frame_velocity = linear_velocity
	
	if level.cue_ball_active:
		check_cue_ball_still_moving()
		trigger_constant_effects()




