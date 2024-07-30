extends Node2D

var balls_moving = false
var cue_ball_active = false
var shot_count = 0
@export var cue_balls:Array[Global.CUE_BALL_TYPES] = []

func check_balls_are_moving():
	balls_moving = false
	for ball:RigidBody2D in get_tree().get_nodes_in_group("balls"):
		if ball.linear_velocity.length() >= Global.BALL_MOVING_THRESHHOLD:
			balls_moving = true

func _physics_process(delta):
	check_balls_are_moving()
