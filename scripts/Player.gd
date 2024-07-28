extends Sprite2D

const POWER_INCREMENT = 0.2 # Speed the power charges at
const MAX_POWER = 20
const BALL_MOVING_THRESHHOLD = 1

@onready var cue_ball = $"../CueBall"
@onready var debug_power = $"../../DebugPower"


var balls_moving = false
var power = 0


func handle_input(delta):
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
	if Input.is_action_pressed("shoot"):
		increase_power(delta)
	if Input.is_action_just_released("shoot"):
		shoot()
		
func increase_power(delta):
	debug_power.text = "Power: " + str(power)
	if power < MAX_POWER:
		power = power + POWER_INCREMENT - delta
		
func shoot():
	cue_ball.apply_central_impulse(power * (get_global_mouse_position() - global_position))
	power = 0

func angle_cue():
	look_at(get_global_mouse_position())

func position_cue():
	global_position = cue_ball.global_position

func check_balls_are_moving():
	balls_moving = false
	for ball:RigidBody2D in get_tree().get_nodes_in_group("balls"):
		if ball.linear_velocity.length() >= BALL_MOVING_THRESHHOLD:
			balls_moving = true

func _process(delta):
	check_balls_are_moving()
	if !balls_moving:
		position_cue()
		angle_cue()
		handle_input(delta)
