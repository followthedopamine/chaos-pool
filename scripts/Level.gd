extends Node2D

const BALL_1 = preload("res://images/sprites/Ball.png")
const BALL_2 = preload("res://images/sprites/Ball.png")
const BALL_8 = preload("res://images/sprites/Ball.png")

const BALL_TEXTURES = [BALL_1, BALL_2, BALL_8]



var prev_balls_moving = false
var cue_ball_active = false

signal balls_stopped

@onready var cue_ball = $CueBall
@export var cue_balls:Array[Global.CUE_BALL_TYPES] = []

var shot_counter = 0

func _ready():
	var ball_counter = 0
	for ball:RigidBody2D in get_tree().get_nodes_in_group("balls"):
		if ball != cue_ball:
			# NOTE: Sprite MUST be first child for this to work
			ball.get_child(0).texture = BALL_TEXTURES[ball_counter % BALL_TEXTURES.size()]
			ball_counter += 1

func fail_level():
	print("You lose")

func _on_balls_stopped():
	pass
	
func _on_cue_shoot():
	cue_ball_active = true
	
func set_cue_ball_inactive():
	cue_ball_active = false
	
func _on_cue_ball_stopped():
	call_deferred("set_cue_ball_inactive")

func check_balls_are_moving():
	if cue_ball_active:
		return
	var balls_moving = false
	for ball:RigidBody2D in get_tree().get_nodes_in_group("balls"):
		if ball.linear_velocity.length() >= Global.BALL_MOVING_THRESHHOLD:
			balls_moving = true
	if balls_moving != prev_balls_moving:
		prev_balls_moving = balls_moving
		if balls_moving == false:
			if shot_counter == cue_balls.size() - 1:
				fail_level()
			else:
				shot_counter += 1
				balls_stopped.emit()

func _physics_process(_delta):
	check_balls_are_moving()





