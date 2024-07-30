extends Sprite2D

const POWER_INCREMENT = 0.2 # Speed the power charges at
const MAX_POWER = 20

@onready var cue_ball = $"../CueBall"
@onready var level = $".."


var power = 0

func handle_input(delta):
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
	if Input.is_action_pressed("shoot"):
		increase_power(delta)
	if Input.is_action_just_released("shoot"):
		shoot_cue_ball()
		
func increase_power(delta):
	if power < MAX_POWER:
		power = power + POWER_INCREMENT - delta
		
func shoot_cue_ball():
	cue_ball.apply_central_impulse(power * (get_global_mouse_position() - global_position))
	power = 0
	level.cue_ball_active = true

func angle_cue():
	look_at(get_global_mouse_position())

func position_cue():
	global_position = cue_ball.global_position
	
func _process(delta):
	if !level.balls_moving:
		position_cue()
		angle_cue()
		handle_input(delta)

