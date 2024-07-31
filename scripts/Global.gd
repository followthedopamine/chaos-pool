extends Node2D

enum CUE_BALL_TYPES {
	STANDARD,
	EXPLOSIVE,
	WORMHOLE,
	PUSHER,
	INFINITE
}

const STANDARD_PLACEHOLDER = preload("res://images/placeholder/cue-ball-placeholder.png")
const EXPLOSIVE_PLACEHOLDER = preload("res://images/sprites/Ball Animations-Sheet.png")
const WORMHOLE_PLACEHOLDER = preload("res://images/placeholder/wormhole-placeholder.png")
const PUSHER_PLACEHOLDER = preload("res://images/placeholder/pusher-placeholder.png")
const INFINITE_PLACEHOLDER = preload("res://images/placeholder/infinite-placeholder.png")

const CUE_BALL_SPRITES = [	
							STANDARD_PLACEHOLDER, 
							EXPLOSIVE_PLACEHOLDER, 
							WORMHOLE_PLACEHOLDER, 
							PUSHER_PLACEHOLDER, 
							INFINITE_PLACEHOLDER
						 ]
						
# [HFrames, Frame]
const CUE_BALL_SPRITE_INFO = [
	[1, 0],
	[16, 1],
	[1, 0],
	[1, 0],
	[1, 0],
]

const BALL_MOVING_THRESHHOLD = 1
