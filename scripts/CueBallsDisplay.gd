extends BoxContainer

@onready var level = $"../.."
@onready var arrow_animation = $"../Arrow/AnimationPlayer"

func create_ball_texture_rects():
	var count = 0
	for cue_ball in level.cue_balls:
		if count != 0:
			var new_cue_ball = TextureRect.new()
			new_cue_ball.texture = Global.CUE_BALL_FLATS[cue_ball]
			add_child(new_cue_ball)
		count += 1
		
func remove_first_ball():
	get_child(0).queue_free()

func _ready():
	level.balls_stopped.connect(_on_balls_stopped)
	create_ball_texture_rects()
	arrow_animation.play("arrow_spin")

func _on_balls_stopped():
	remove_first_ball()
