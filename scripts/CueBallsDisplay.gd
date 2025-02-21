extends BoxContainer

@onready var level = $"../.."
@onready var arrow_animation = $"../Arrow/AnimationPlayer"

enum {
	NONE,
	TABLE_BALL_DESPAWN,
	TABLE_BALL_SPAWN,
	BALLS_ROLLING
}

var animation_timers = [0.3, 0.3, 0.3]

var animation_state = NONE

const DROP_SPEED = 200

const ROLL_SPEED = 200

var target_position

@onready var initial_position = position
@onready var ball_width = get_child(0).get_rect().size.x

var separation = self["theme_override_constants/separation"]

func create_ball_texture_rects():
	var count = 0
	for cue_ball in level.cue_balls:
		if count != 0:
			var new_cue_ball = TextureRect.new()
			new_cue_ball.texture = Global.CUE_BALL_FLATS[cue_ball]
			var pivot_point = Vector2(new_cue_ball.texture.get_width() / 2, new_cue_ball.texture.get_height() / 2)
			new_cue_ball.pivot_offset = pivot_point
			add_child(new_cue_ball)
		count += 1
		
func remove_first_ball():
	animation_state = TABLE_BALL_DESPAWN
	await get_tree().create_timer(animation_timers[0]).timeout
	animation_state = TABLE_BALL_SPAWN
	#await get_tree().create_timer(animation_timers[1]).timeout
	target_position = Vector2(initial_position.x - (ball_width + separation), position.y)
	#Debug.draw_dot(target_position)
	#animation_state = BALLS_ROLLING
	
func animate_ball_drop_out_of_display(delta):
	var first_ball = get_child(0)
	first_ball.position.y += DROP_SPEED * delta
	
func animate_ball_spiral_out(delta):
	var first_ball = get_child(0)
	if first_ball.scale.x > 0.1:
		first_ball.scale -= Vector2(3, 3) * delta
	else:
		print("Ball is fully spiraled out")
		first_ball.scale = Vector2.ZERO
		first_ball.visible = false
		animation_state = BALLS_ROLLING
	#first_ball.rotation += 0.1
	
func animate_balls_rolling(delta):
	print("Position: " + str(position.x - target_position.x))
	if position.x - target_position.x < 0:
		get_child(0).queue_free()
		position.x = initial_position.x
		animation_state = NONE
	else:
		position.x -= ROLL_SPEED * delta
		Debug.draw_dot(position)
		#var balls = get_children()
		#for ball in balls:
			## Add ball rotation here possibly
			#pass
	
func remove_display_balls():
	for i in get_children():
		i.queue_free()

func _ready():
	remove_display_balls()
	level.balls_stopped.connect(_on_balls_stopped)
	create_ball_texture_rects()
	#arrow_animation.play("arrow_spin")

func _on_balls_stopped():
	remove_first_ball()
	
func _process(delta):
	if animation_state == TABLE_BALL_SPAWN:
		#animate_ball_drop_out_of_display(delta)
		animate_ball_spiral_out(delta)
	if animation_state == BALLS_ROLLING:
		animate_balls_rolling(delta)
