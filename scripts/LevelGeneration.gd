extends Node2D

const BALL_1 = preload("res://images/placeholder/1-ball-placeholder.png")
const BALL_2 = preload("res://images/placeholder/2-ball-placeholder.png")
const BALL_8 = preload("res://images/placeholder/8-ball-placeholder.png")

const BALL_TEXTURES = [BALL_1, BALL_2, BALL_8]

const BALL_MOVING_THRESHHOLD = 1

var prev_balls_moving = false

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

func add_shot():
	shot_counter += 1
	
func _on_cue_shoot():
	add_shot()
	
func check_balls_are_moving():
	var balls_moving = false
	for ball:RigidBody2D in get_tree().get_nodes_in_group("balls"):
		if ball.linear_velocity.length() >= BALL_MOVING_THRESHHOLD:
			balls_moving = true
	if balls_moving != prev_balls_moving:
		prev_balls_moving = balls_moving
		if balls_moving == false:
			balls_stopped.emit()
			
func _physics_process(delta):
	check_balls_are_moving()
