extends Sprite2D

const POWER_INCREMENT = 0.5 # Speed the power charges at
const MIN_POWER = POWER_INCREMENT
const MAX_POWER = 100
const POWER_FACTOR = 20

const MAX_SHOT_CHARGE_Y = 37
const MIN_SHOT_CHARGE_Y = -35

const DEFAULT_CUE_X_OFFSET = -126
const MAX_CUE_X_OFFSET = -180

const SHOT_SOUND = preload("res://sounds/Shot.mp3")
const SHOT_MIN_VOLUME = 3

const MINIMUM_TIME_BETWEEN_SHOTS = 0.2
const TIME_TO_HIDE_SHOT_CHARGE = 0.5

var cue_balls_display

@onready var cue_ball = $"../CueBall"
@onready var cue_ball_shape = $"../CueBall/CueBallCollision"
@onready var level = $".."
@onready var options_menu = $"../../OptionsMenu"
@onready var level_menu_button = $"../../LevelButtons"
@onready var shot_charge = $ShotChargeMask/ShotCharge
@onready var shot_charge_mask = $ShotChargeMask

@onready var initial_x_offset = offset.x

var power_is_increasing = true
var power = 0

var level_is_loading = true
var last_shot = -1

var hit_points

signal shoot

func _ready():
	# Don't start handling input immediately or shot will fire from menu click
	level.level_loaded.connect(_on_level_loaded)
	await get_tree().create_timer(0.05).timeout
	level_is_loading = false
	
func _on_level_loaded():
	cue_balls_display = level.cue_balls_display.get_child(0)
	
func handle_unrestricted_input():
	if Input.is_action_just_pressed("reset"):
		Scene.reload_current_level()

func handle_input(delta):
	if Input.is_action_pressed("shoot"):
		update_power(delta)
	if Input.is_action_just_released("shoot"):
		shoot_cue_ball()

func get_player_target():
	if Config.reverse_aim:
		return global_position * 2 - get_global_mouse_position()
	return get_global_mouse_position()
	
func get_player_press_location():
	return get_global_mouse_position()
	
func get_player_target_direction():
	var direction = (get_player_target() - global_position).normalized()
	return direction
		
func update_charge_display():
	if power != 0:
		shot_charge_mask.visible = true
		var percentage = power/MAX_POWER * 2
		shot_charge.position.y = min((percentage * MAX_SHOT_CHARGE_Y) - abs(MIN_SHOT_CHARGE_Y), MAX_SHOT_CHARGE_Y)
		
func hide_shot_charge():
	await get_tree().create_timer(TIME_TO_HIDE_SHOT_CHARGE).timeout
	shot_charge_mask.visible = false
	
func animate_cue(delta):
	const CUE_ANIMATION_DISTANCE = 0.6 
	offset.x = initial_x_offset - (power * CUE_ANIMATION_DISTANCE)
		
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
	print("Fired shot " + str(level.shot_counter))
	cue_ball.apply_central_impulse(POWER_FACTOR * power * (get_player_target() - global_position).normalized())
	print("Shot power: %s" % power )
	power = MIN_POWER
	hide_shot_charge()
	Sound.create_sound_and_play(SHOT_SOUND, SHOT_MIN_VOLUME + power,self)
	level.cue_ball_active = true
	# Fixes a bug where cue ball would instantly become inactive 
	cue_ball.frames_below_threshold = 0
	level.balls_stopped_frames = 0
	level.prev_balls_moving = true
	last_shot = level.shot_counter
	await get_tree().create_timer(MINIMUM_TIME_BETWEEN_SHOTS).timeout

func angle_cue():
	look_at(get_player_target())

func position_cue():
	global_position = cue_ball.global_position
	
func check_if_player_is_pressing_menu():
	var rect = level_menu_button.get_global_rect()
	if rect.has_point(get_player_press_location()):
		return true
	return false
	
func cast_line():
	var extended_point = global_position + get_player_target_direction() * 1000
	var space_state = get_world_2d().direct_space_state

	var parameters = PhysicsShapeQueryParameters2D.new()
	parameters.shape = cue_ball_shape.shape
	parameters.transform = Transform2D(0, global_position)
	parameters.motion = extended_point - global_position
	parameters.exclude = [self, cue_ball]
	
	#var results = space_state.intersect_shape(parameters)
	
	var has_collision = space_state.collide_shape(parameters)
	var closest_point = extended_point
	var closest_distance = INF
	hit_points = []
	if has_collision:
		for collision in has_collision:
			#var distance = global_position.distance_to(collision)
			#if distance < closest_distance:
				#closest_distance = distance
				#closest_point = collision
		#hit_points = closest_point
			hit_points.append(collision)
	queue_redraw()
	
func cast_shape():
	var extended_point = global_position + get_player_target_direction() * 1000
	var shape_cast = ShapeCast2D.new()
	shape_cast.shape = cue_ball_shape.shape
	shape_cast.position = cue_ball.position
	shape_cast.target_position = extended_point
	#print(shape_cast.collision_result)
	hit_points = extended_point
	for i in range(0, shape_cast.get_collision_count()):
		print(shape_cast.get_collision_point(i))
		
	queue_redraw()
	
	
func can_handle_input() -> bool:
	if cue_balls_display.animation_state != cue_balls_display.NONE:
		return false
	if last_shot == level.shot_counter:
		return false
	if level_is_loading:
		return false
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

func _physics_process(delta):
	handle_unrestricted_input()
	
	if can_handle_input():
		#cast_line()
		cast_shape()
		position_cue()
		angle_cue()
		handle_input(delta)
		animate_cue(delta)
		


#func _draw():
	#if hit_points != null:
		#draw_line(to_local(global_position), to_local(hit_points), Color.WHITE, 1.0)
	#if hit_points != null:
		##draw_circle(to_local(hit_point), cue_ball_shape.shape.radius, Color(1, 0, 0, 0.3))
		#for hit_point in hit_points:
			#draw_line(to_local(global_position), to_local(hit_point), Color.WHITE, 1.0)
