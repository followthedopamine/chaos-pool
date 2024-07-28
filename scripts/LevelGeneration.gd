extends Node2D

const BALL_1 = preload("res://images/placeholder/1-ball-placeholder.png")
const BALL_2 = preload("res://images/placeholder/2-ball-placeholder.png")
const BALL_8 = preload("res://images/placeholder/8-ball-placeholder.png")

const BALL_TEXTURES = [BALL_1, BALL_2, BALL_8]

@onready var cue_ball = $CueBall


func _ready():
	var ball_counter = 0
	for ball:RigidBody2D in get_tree().get_nodes_in_group("balls"):
		if ball != cue_ball:
			# NOTE: Sprite MUST be first child for this to work
			ball.get_child(0).texture = BALL_TEXTURES[ball_counter % BALL_TEXTURES.size()]
			ball_counter += 1
