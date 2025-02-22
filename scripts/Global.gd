extends Node2D

enum CUE_BALL_TYPES {
	STANDARD,
	EXPLOSIVE,
	WORMHOLE,
	PUSHER,
	INFINITE
}

const STANDARD_SPRITE = preload("res://images/sprites/cue-ball-texture.png")
const EXPLOSIVE_SPRITE = preload("res://images/sprites/explosive-ball.png")
const WORMHOLE_SPRITE = preload("res://images/sprites/wormhole-ball.png")
const PUSHER_PLACEHOLDER = preload("res://images/sprites/Pusher-Ball.png")
const INFINITE_PLACEHOLDER = preload("res://images/placeholder/infinite-placeholder.png")

const STANDARD_FLAT = preload("res://images/sprites/Cue-Ball.png")

const CUE_BALL_SPRITES = [	
							STANDARD_SPRITE, 
							EXPLOSIVE_SPRITE, 
							WORMHOLE_SPRITE, 
							PUSHER_PLACEHOLDER, 
							INFINITE_PLACEHOLDER
						 ]
						
const CUE_BALL_FLATS = [
						STANDARD_FLAT, 
						EXPLOSIVE_SPRITE, 
						WORMHOLE_SPRITE, 
						PUSHER_PLACEHOLDER, 
						INFINITE_PLACEHOLDER
						]
						
#const STANDARD_ANIMATION = preload("res://images/sprites/Ball Animations-Sheet.png")
#const EXPLOSIVE_ANIMATION = preload("res://images/sprites/Ball Animations-Sheet.png")
#const WORMHOLE_ANIMATION = preload("res://images/sprites/Ball Animations-Sheet.png")
#const PUSHER_ANIMATION = preload("res://images/sprites/Ball Animations-Sheet.png")
#const INFINITE_ANIMATION = preload("res://images/sprites/Ball Animations-Sheet.png")
#
#
#const CUE_BALL_ANIMATIONS = [
	#STANDARD_ANIMATION,
	#EXPLOSIVE_ANIMATION,
	#WORMHOLE_ANIMATION,
	#PUSHER_ANIMATION,
	#INFINITE_ANIMATION
#]
## [HFrames, Frame]
#const CUE_BALL_ANIMATION_INFO = [
	#[1, 0],
	#[16, 1],
	#[1, 0],
	#[1, 0],
	#[1, 0],
#]

const BALL_MOVING_THRESHHOLD = 1
