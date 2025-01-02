extends BoxContainer

@onready var level = $"../.."
@onready var arrow_animation = $"../Arrow/AnimationPlayer"

enum {
	NONE,
	DISPLAY_DROP,
	TABLE_DROP,
	BALLS_ROLLING
}

var animation_timers = [0.5, 0.5, 0.5]

var animation_state = NONE

const DROP_SPEED = 200

const ROLL_SPEED = 200

var target_position

@onready var initial_position = position

var separation = self["theme_override_constants/separation"]

func create_ball_texture_rects():
	var count = 0
	for cue_ball in level.cue_balls:
		if count != 0:
			var new_cue_ball = TextureRect.new()
			new_cue_ball.texture = Global.CUE_BALL_FLATS[cue_ball]
			add_child(new_cue_ball)
		count += 1
		
func remove_first_ball():
	animation_state = DISPLAY_DROP
	await get_tree().create_timer(animation_timers[0]).timeout
	target_position = position + get_child(0).get_rect().size + Vector2(separation,separation)
	animation_state = BALLS_ROLLING
	
func animate_ball_drop_out_of_display(delta):
	var first_ball = get_child(0)
	first_ball.position.y += DROP_SPEED * delta
	
func animate_balls_rolling(delta):
	print(abs(position.x - target_position.x))
	if abs(position.x - target_position.x) < 1:
		get_child(0).queue_free()
		position.x = initial_position.x
		animation_state = NONE
	else:
		position.x += ROLL_SPEED * delta
		
		var balls = get_children()
		for ball in balls:
			pass
	
func remove_display_balls():
	for i in get_children():
		i.queue_free()

func _ready():
	remove_display_balls()
	level.balls_stopped.connect(_on_balls_stopped)
	create_ball_texture_rects()
	arrow_animation.play("arrow_spin")

func _on_balls_stopped():
	remove_first_ball()
	
func _process(delta):
	if animation_state == DISPLAY_DROP:
		animate_ball_drop_out_of_display(delta)
	if animation_state == BALLS_ROLLING:
		animate_balls_rolling(delta)
