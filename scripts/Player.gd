extends Sprite2D

const POWER_INCREMENT = 0.2 # Speed the power charges at
const MAX_POWER = 20

@onready var cue_ball = $"../CueBall"
@onready var debug_power = $"../DebugPower"


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
	if !balls_moving:
		global_position = cue_ball.global_position

func _ready():
	pass

func _process(delta):
	position_cue()
	angle_cue()
	handle_input(delta)
