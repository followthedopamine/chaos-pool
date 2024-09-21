extends Control

const _0 = preload("res://images/ui/numbers/0-number.png")
const _1 = preload("res://images/ui/numbers/1-number.png")
const _2 = preload("res://images/ui/numbers/2-number.png")
const _3 = preload("res://images/ui/numbers/3-number.png")
const _4 = preload("res://images/ui/numbers/4-number.png")
const _5 = preload("res://images/ui/numbers/5-number.png")
const _6 = preload("res://images/ui/numbers/6-number.png")
const _7 = preload("res://images/ui/numbers/7-number.png")
const _8 = preload("res://images/ui/numbers/8-number.png")
const _9 = preload("res://images/ui/numbers/9-number.png")

@onready var digit_1 = $"TimerHBoxContainer/Digit 1"
@onready var digit_2 = $"TimerHBoxContainer/Digit 2"
@onready var digit_3 = $"TimerHBoxContainer/Digit 3"
@onready var digit_4 = $"TimerHBoxContainer/Digit 4"
@onready var digit_5 = $"TimerHBoxContainer/Digit 5"
@onready var digit_6 = $"TimerHBoxContainer/Digit 6"




var time_elapsed = 0.0

var is_paused = false

func _ready():
	pass # Replace with function body.

func start_timer():
	pass
	
func pause_timer():
	pass
	
func get_digit_variable(digit_number):
	match digit_number:
		1: return digit_1
		2: return digit_2
		3: return digit_3
		4: return digit_4
		5: return digit_5
		6: return digit_6
		
func get_number_variable(number:String):
	match number:
		"0": return _0
		"1": return _1
		"2": return _2
		"3": return _3
		"4": return _4
		"5": return _5
		"6": return _6
		"7": return _7
		"8": return _8
		"9": return _9
		

func update_numbers():
	var minutes = time_elapsed / 60
	var seconds = fmod(time_elapsed, 60)
	var milliseconds = fmod(time_elapsed, 1) * 100
	var time_string = "%02d%02d%02d" % [minutes, seconds, milliseconds]
	var count = 0
	for char in time_string:
		count += 1
		var digit = get_digit_variable(count)
		digit.texture = get_number_variable(char)
		
func is_level_ended():
	if is_instance_valid(Scene.current_level_script):
		if !Scene.current_level_script.level_ended:
			return false
	return true

func _process(delta):
	if !is_paused and !is_level_ended():
		time_elapsed += delta
		update_numbers()
