extends Node2D
const BALL_1_TEXTURE = preload("res://images/sprites/1-ball-texture.png")
const BALL_2_TEXTURE = preload("res://images/sprites/2-ball-texture.png")
const BALL_3_TEXTURE = preload("res://images/sprites/3-ball-texture.png")
const BALL_4_TEXTURE = preload("res://images/sprites/4-ball-texture.png")
const BALL_5_TEXTURE = preload("res://images/sprites/5-ball-texture.png")
const BALL_6_TEXTURE = preload("res://images/sprites/6-ball-texture.png")
const BALL_7_TEXTURE = preload("res://images/sprites/7-ball-texture.png")
const BALL_8_TEXTURE = preload("res://images/sprites/8-ball-texture.png")
const BALL_9_TEXTURE = preload("res://images/sprites/9-ball-texture.png")
const BALL_10_TEXTURE = preload("res://images/sprites/10-ball-texture.png")
const BALL_11_TEXTURE = preload("res://images/sprites/11-ball-texture.png")
const BALL_12_TEXTURE = preload("res://images/sprites/12-ball-texture.png")
const BALL_13_TEXTURE = preload("res://images/sprites/13-ball-texture.png")
const BALL_14_TEXTURE = preload("res://images/sprites/14-ball-texture.png")
const BALL_15_TEXTURE = preload("res://images/sprites/15-ball-texture.png")
const BALL_TEXTURES = [
	BALL_1_TEXTURE,
	BALL_2_TEXTURE,
	BALL_3_TEXTURE,
	BALL_4_TEXTURE,
	BALL_5_TEXTURE,
	BALL_6_TEXTURE,
	BALL_7_TEXTURE,
	#BALL_8_TEXTURE,
	BALL_9_TEXTURE,
	BALL_10_TEXTURE,
	BALL_11_TEXTURE,
	BALL_12_TEXTURE,
	BALL_13_TEXTURE,
	BALL_14_TEXTURE,
	BALL_15_TEXTURE
]

const BALL_LIGHTING_2 = preload("res://images/sprites/Ball_Lighting_2.png")
const COOL_BALLS = [1,3,5,8,10,12]

const TIME = preload("res://scenes/Time.tscn")
const CUE_BALLS_DISPLAY = preload("res://scenes/Cue_Balls_Display.tscn")
const TABLE_BACKGROUND = preload("res://scenes/Table_Background.tscn")

var time = null
var balls_stopped_frames = 0
const BALLS_STOPPED_THRESHOLD = 3
var prev_balls_moving = false
var cue_ball_active = false
var balls_moving = false
signal balls_stopped
@onready var cue_ball = $CueBall
@export var cue_balls:Array[Global.CUE_BALL_TYPES] = []
@onready var level_end = $"../LevelEnd"
var shot_counter = 0
var active_balls = []  # Track currently active balls
var level_ended = false
var level_reset = false
var available_textures = []  # Track available textures
var cue_balls_display
signal level_loaded

func _ready():
	Scene.current_level_script = self
	setup_level()
	
func instantiate_level_scenes():
	time = TIME.instantiate()
	add_child(time)
	level_end.level_timer = time
	cue_balls_display = CUE_BALLS_DISPLAY.instantiate()
	add_child(cue_balls_display)
	var table_background = TABLE_BACKGROUND.instantiate()
	add_child(table_background)
	
func handle_portrait_resolution():
	if Resolution.display_mode == Resolution.PORTRAIT:
		Resolution.adjust_level_components(self)
	
func setup_level():
	instantiate_level_scenes()
	handle_portrait_resolution()
	active_balls.clear()  # Clear the tracking array
	available_textures = BALL_TEXTURES.duplicate()  # Reset available textures
	randomize()  # Initialize random number generator
	
	for ball: RigidBody2D in get_tree().get_nodes_in_group("balls"):
		if is_instance_valid(ball) and !ball.is_queued_for_deletion():
			if ball.get_parent() == self and ball != cue_ball:
				# Add ball to tracking array
				active_balls.append(ball)
				# Get random texture from available ones
				var ball_sprite = ball.get_child(0).get_child(0)
				if ball_sprite and available_textures.size() > 0:
					var random_index = randi() % available_textures.size()
					var original_index = BALL_TEXTURES.find(available_textures[random_index])
					if original_index in COOL_BALLS:
						var ball_shading = ball.get_child(1)
						ball_shading.texture = BALL_LIGHTING_2
					ball_sprite.texture = available_textures[random_index]
					# Remove used texture from available ones
					available_textures.remove_at(random_index)
	
	print("Initial ball count: ", active_balls.size())
	level_loaded.emit()

func ball_destroyed(ball: RigidBody2D):
	var ball_index = active_balls.find(ball)
	#print(ball_index)
	if ball_index != -1:  # Ball was found in array
		active_balls.remove_at(ball_index)
		print("Ball destroyed. Remaining balls: ", active_balls.size())
		
		# Check win condition immediately when a ball is destroyed
		if active_balls.is_empty() and !level_ended:
			succeed_level()

func fail_level():
	if level_ended:
		return
	print("You lose")
	level_end.show_loss_screen()
	level_ended = true
	
func succeed_level():
	if level_ended:
		return
	print("You win")
	var star_score = cue_balls.size() - shot_counter
	print("Star score: ", star_score)
	var level_number = Scene.current_level
	Save.save_stars(level_number, star_score)
	level_end.show_win_screen(star_score)	
	level_ended = true
	
func set_cue_ball_inactive():
	cue_ball_active = false
	
func on_cue_ball_stopped():
	call_deferred("set_cue_ball_inactive")

func check_if_balls_are_moving():
	if cue_ball_active:
		return true
	
	for ball in active_balls:
		if ball.linear_velocity.length() > Global.BALL_MOVING_THRESHHOLD:
			balls_stopped_frames = 0
			prev_balls_moving = true
			return true
	
	if balls_stopped_frames >= BALLS_STOPPED_THRESHOLD:
		if prev_balls_moving == true:
			prev_balls_moving = false
			handle_balls_stopped()
		return false
		
	balls_stopped_frames += 1
			
func handle_balls_stopped():
	if active_balls.is_empty():
		succeed_level()
	elif shot_counter == cue_balls.size() - 1:
		fail_level()
	else:
		shot_counter += 1
		cue_ball.need_new_cue_ball = true
		balls_stopped.emit()
		print("Balls stopped. Remaining balls: ", active_balls.size())

func _physics_process(_delta):
	check_if_balls_are_moving()
