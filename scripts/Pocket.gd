extends Area2D

@onready var cue_ball = $"../../CueBall"
@onready var level = $"../.."
var ball_sinking
var ball_sinking_sprite: Sprite2D
const FADE_OUT_SPEED = 7
const SHRINK_SPEED = 0.6

# TODO: Script is set up in a way that only one ball can sink at a time

func play_sinking_animation(delta):
	# Disable wormhole effect
	if ball_sinking:
		ball_sinking.position = position
		ball_sinking.linear_velocity = Vector2.ZERO
		ball_sinking.modulate.a -= FADE_OUT_SPEED * delta
		if ball_sinking.scale > Vector2.ZERO:
			ball_sinking.scale -= Vector2(SHRINK_SPEED, SHRINK_SPEED) * delta
		else:
			ball_sinking.scale = Vector2.ZERO
			safely_destroy_ball(ball_sinking)

func _on_body_entered(body: RigidBody2D):
	if body.is_in_group("balls"):
		if body == cue_ball:
			sink_cue_ball()
		ball_sinking = body
		# Only works if sprite is child 0
		ball_sinking_sprite = ball_sinking.get_child(0)

		await get_tree().create_timer(0.4).timeout
		if body == cue_ball:
			cue_ball.is_sinking = false
			level.cue_ball_active = false
			cue_ball.respawn_cue_ball()
		ball_sinking = false
		
func sink_cue_ball():
	cue_ball.wormhole_animated_sprite.visible = false
	cue_ball.pusher_animated_sprite.visible = false
	cue_ball.is_sinking = true

func safely_destroy_ball(body: RigidBody2D):
	if is_instance_valid(body) and !body.is_queued_for_deletion():
		if body != cue_ball:
			level.ball_destroyed(body)
		body.queue_free()

func _process(delta):
	if ball_sinking:
		play_sinking_animation(delta)
