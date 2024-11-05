extends Area2D
@onready var cue_ball = $"../../CueBall"
@onready var level = $"../.."
var ball_sinking
var ball_sinking_sprite: Sprite2D
var ball_velocity: float
const FADE_OUT_SPEED = 12
const SHRINK_SPEED = 10
const BALL_SPEED = 2

func does_ball_need_to_move():
	var distance_from_pocket = abs(ball_sinking.position - position)
	if(distance_from_pocket.length() > 2):
		return true
	return false

func move_ball_to_pocket_center(delta):
	if(does_ball_need_to_move()):
		
		var direction = position - ball_sinking.position
		var movement = direction.normalized() * delta * BALL_SPEED * ball_velocity
		# Don't move further than the remaining distance
		if movement.length() > direction.length():
			ball_sinking.position = position
		else:
			ball_sinking.position += movement  
	else:
		ball_sinking.position = position

func play_sinking_animation(delta):
	if(does_ball_need_to_move()):
		return
	ball_sinking.modulate.a -= FADE_OUT_SPEED * delta
	if ball_sinking_sprite.scale > Vector2.ZERO:
		var shrink_amount = Vector2(SHRINK_SPEED, SHRINK_SPEED) * delta
		ball_sinking_sprite.scale -= shrink_amount
	else:
		ball_sinking_sprite.scale = Vector2.ZERO
		safely_destroy_ball(ball_sinking)
		
func get_ball_speed_toward_pocket(ball):
	var direction = (global_position - ball.global_position).normalized()
   
   # Get the dot product of velocity and direction
   # This gives you the magnitude of velocity in the direction of the area
	var speed_toward = ball.linear_velocity.dot(direction)
	return speed_toward

func _on_body_entered(body: RigidBody2D):
	if body.is_in_group("balls"):
		if body == cue_ball:
			sink_cue_ball()
		ball_sinking = body
		ball_sinking_sprite = ball_sinking.get_child(0)
		
		ball_velocity = get_ball_speed_toward_pocket(body)
		ball_sinking.set_deferred("linear_velocity", Vector2.ZERO)
		ball_sinking.set_deferred("angular_velocity", 0)
		ball_sinking.set_deferred("freeze", true)
		
		

func sink_cue_ball():
	cue_ball.wormhole_animated_sprite.visible = false
	cue_ball.pusher_animated_sprite.visible = false
	cue_ball.is_sinking = true

func safely_destroy_ball(body: RigidBody2D):
	if is_instance_valid(body) and !body.is_queued_for_deletion():
		if body == cue_ball:
			cue_ball.is_sinking = false
			level.cue_ball_active = false
			cue_ball.respawn_cue_ball()
			if !level.balls_moving:
				level.handle_balls_stopped()
		else:
			level.ball_destroyed(body)
			body.queue_free()
		ball_sinking = null

func _process(delta):
	if ball_sinking:
		move_ball_to_pocket_center(delta)
		play_sinking_animation(delta)
