extends Sprite2D

const POWER_INCREMENT = 0.2 # Speed the power charges at
const MIN_POWER = POWER_INCREMENT
const MAX_POWER = 20

const MAX_SHOT_CHARGE_Y = 37
const MIN_SHOT_CHARGE_Y = -35

const DEFAULT_CUE_X_OFFSET = -126
const MAX_CUE_X_OFFSET = -180


@onready var cue_ball = $"../CueBall"
@onready var level = $".."

@onready var options_menu = $"../../OptionsMenu"
@onready var level_menu_button = $"../../LevelMenuButton"



@onready var shot_charge = $ShotChargeMask/ShotCharge
@onready var shot_charge_mask = $ShotChargeMask

const SHOT_SOUND = preload("res://sounds/Shot.mp3")
const SHOT_MIN_VOLUME = 3

var power_is_increasing = true

var power = 0

signal shoot

func handle_input(delta):
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
	if Input.is_action_pressed("shoot"):
		update_power(delta)
	if Input.is_action_just_released("shoot") and power > 0:
		shoot_cue_ball()
		
func update_charge_display():
	# value/value total * 100
	if power != 0:
		shot_charge_mask.visible = true
		var percentage = power/MAX_POWER * 2
		shot_charge.position.y = min((percentage * MAX_SHOT_CHARGE_Y) - abs(MIN_SHOT_CHARGE_Y), MAX_SHOT_CHARGE_Y)
		
func hide_shot_charge():
	await get_tree().create_timer(0.5).timeout
	shot_charge_mask.visible = false
		
func update_power(delta):
	if power >= MAX_POWER:
		power_is_increasing = false
	if power <= MIN_POWER:
		power_is_increasing = true
		
	if power_is_increasing:
		if power < MAX_POWER:
			power = power + POWER_INCREMENT - delta
	else:
		if power > MIN_POWER:
			power = power - POWER_INCREMENT + delta
	update_charge_display()
		
func shoot_cue_ball():
	cue_ball.apply_central_impulse(power * (get_global_mouse_position() - global_position))
	power = 0
	hide_shot_charge()
	Sound.create_sound_and_play(SHOT_SOUND, SHOT_MIN_VOLUME + power,self)
	#await get_tree().create_timer(0.1).timeout #Necessary to make sure signal isn't recieved before ball is moving
	##shoot.emit()
	level.cue_ball_active = true

func angle_cue():
	look_at(get_global_mouse_position())

func position_cue():
	global_position = cue_ball.global_position
	
func check_if_player_is_pressing_menu():
	var rect = level_menu_button.get_global_rect()
	if rect.has_point(get_global_mouse_position()):
		return true
	return false
	
func can_handle_input() -> bool:
	if level.cue_ball_active:
		return false
	if level.balls_moving: 
		return false
	if level.level_ended:
		return false 
	if options_menu.visible:
		return false
	if check_if_player_is_pressing_menu():
		return false
	if cue_ball.is_sinking:
		return false
	return true

func _process(delta):
	if can_handle_input():
		position_cue()
		angle_cue()
		handle_input(delta)



