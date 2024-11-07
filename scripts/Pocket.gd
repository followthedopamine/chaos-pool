extends Area2D
@onready var cue_ball = $"../../CueBall"
@onready var level = $"../.."
var balls_sinking = []
#var ball_sinking_sprite: Sprite2D
#var ball_velocity: float
const FADE_OUT_SPEED = 6
const SHRINK_SPEED = 5
const BALL_SPEED = 2
const MIN_SINK_SPEED = 15


func does_ball_need_to_move(ball):
	var distance_from_pocket = abs(ball.position - position)
	if(distance_from_pocket.length() > 2):
		return true
	return false

func move_ball_to_pocket_center(delta, ball):
	if(does_ball_need_to_move(ball)):
		# A min ball velocity means ball should never take absurdly long time
		# to enter pocket
		var ball_velocity = max(get_ball_speed_toward_pocket(ball), MIN_SINK_SPEED)
		var direction = position - ball.position
		var movement = direction.normalized() * delta * BALL_SPEED * ball_velocity
		#print(ball_velocity)
		# Don't move further than the remaining distance
		if movement.length() > direction.length():
			ball.position = position
		else:
			ball.position += movement
		if abs(position - ball.position).length() > 40:
			ball.position = position
	else:
		ball.position = position

func play_sinking_animation(delta, ball):
	var ball_sinking_sprite = ball.get_child(0).get_child(0)
	if(does_ball_need_to_move(ball)):
		return
	ball.modulate.a -= FADE_OUT_SPEED * delta
	if ball_sinking_sprite.scale > Vector2.ZERO:
		var shrink_amount = Vector2(SHRINK_SPEED, SHRINK_SPEED) * delta
		ball_sinking_sprite.scale -= shrink_amount
	else:
		ball_sinking_sprite.scale = Vector2.ZERO
		safely_destroy_ball(ball)
		
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
		balls_sinking.append(body)
		
		#body.set_deferred("linear_velocity", Vector2.ZERO)
		#body.set_deferred("angular_velocity", 0)
		body.set_deferred("freeze", true)
		
		

func sink_cue_ball():
	cue_ball.wormhole_animated_sprite.visible = false
	cue_ball.pusher_animated_sprite.visible = false
	cue_ball.is_sinking = true

func safely_destroy_ball(body: RigidBody2D):
	if is_instance_valid(body) and !body.is_queued_for_deletion():
		if body == cue_ball:
			cue_ball.is_sinking = false
			level.cue_ball_active = false
			cue_ball.needs_respawn = true
			#if !level.balls_moving:
				#level.handle_balls_stopped()
		else:
			level.ball_destroyed(body)
			body.queue_free()
		var ball_index = balls_sinking.find(body)
		balls_sinking.remove_at(ball_index)

func _process(delta):
	if !balls_sinking.size() == 0:
		for ball in balls_sinking:
			move_ball_to_pocket_center(delta, ball)
			play_sinking_animation(delta, ball)
