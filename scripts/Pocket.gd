extends Area2D

@onready var cue_ball = $"../../CueBall"
@onready var level = $"../.."

var ball_sinking
var ball_sinking_sprite:Sprite2D


const FADE_OUT_SPEED = 7
const SHRINK_SPEED = 0.6

func play_sinking_animation(delta):
	# Disable wormhole effect
	
	ball_sinking.position = position
	ball_sinking_sprite.modulate.a -= FADE_OUT_SPEED * delta
	if ball_sinking_sprite.scale > Vector2.ZERO:
		ball_sinking_sprite.scale -= Vector2(SHRINK_SPEED, SHRINK_SPEED) * delta
	else:
		ball_sinking_sprite.scale = Vector2.ZERO
		
func _on_body_entered(body:RigidBody2D):
	if body.is_in_group("balls"):
		if body == cue_ball:
			level.set_cue_ball_inactive()
			cue_ball.wormhole_animated_sprite.visible = false
			cue_ball.pusher_animated_sprite.visible = false
		ball_sinking = body
		# Only works if sprite is child 0
		ball_sinking_sprite = ball_sinking.get_child(0)
		print(ball_sinking_sprite.modulate.a)
		
		await get_tree().create_timer(0.4).timeout
		ball_sinking = false
		if body == cue_ball:
			cue_ball.reset()
		else:
			level.ball_counter -= 1
			body.call_deferred("queue_free")

func _process(delta):
	if ball_sinking:
		play_sinking_animation(delta)
