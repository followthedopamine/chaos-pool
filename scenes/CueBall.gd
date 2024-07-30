extends Node2D

const SUCK_MIN_DISTANCE = 100

@onready var level = $".."
@onready var cue_ball_area_of_effect = $CueBallAreaOfEffect


var cue_ball_type

func _ready():
	load_cue_ball()

func load_cue_ball():
	cue_ball_type = level.cue_balls[level.shot_count]

func suck():
	for ball:RigidBody2D in cue_ball_area_of_effect.get_overlapping_bodies():
		if ball != self:
			if abs(ball.global_position - global_position).length() > SUCK_MIN_DISTANCE:
				ball.apply_central_impulse(Vector2(global_position - ball.global_position))

func trigger_constant_effects():
	print("Is triggering constant effects")
	match cue_ball_type:
		Global.CUE_BALL_TYPES.WORMHOLE:
			suck()

func _physics_process(_delta):
	if level.cue_ball_active:
		trigger_constant_effects()
