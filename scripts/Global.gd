extends Node2D

enum CUE_BALL_TYPES {
	STANDARD,
	EXPLOSIVE,
	WORMHOLE,
	PUSHER,
	INFINITE
}

const STANDARD_PLACEHOLDER = preload("res://images/placeholder/cue-ball-placeholder.png")
const EXPLOSIVE_PLACEHOLDER = preload("res://images/placeholder/explosive-placeholder.png")
const WORMHOLE_PLACEHOLDER = preload("res://images/placeholder/wormhole-placeholder.png")
const INFINITE_PLACEHOLDER = preload("res://images/placeholder/infinite-placeholder.png")

const CUE_BALL_SPRITES = [	
							STANDARD_PLACEHOLDER, 
							EXPLOSIVE_PLACEHOLDER, 
							WORMHOLE_PLACEHOLDER, 
							0, 
							INFINITE_PLACEHOLDER
						 ]

const BALL_MOVING_THRESHHOLD = 1
