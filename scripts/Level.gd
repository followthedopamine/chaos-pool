extends Node2D

const BALL_1 = preload("res://images/sprites/Ball.png")
const BALL_2 = preload("res://images/sprites/Ball.png")
const BALL_8 = preload("res://images/sprites/Ball.png")
const BALL_TEXTURES = [BALL_1, BALL_2, BALL_8]

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

func _ready():
	Scene.current_level_script = self
	setup_level()
	
func setup_level():
	active_balls.clear()  # Clear the tracking array
	
	for ball: RigidBody2D in get_tree().get_nodes_in_group("balls"):
		if is_instance_valid(ball) and !ball.is_queued_for_deletion():
			if ball.get_parent() == self and ball != cue_ball:
				# Add ball to tracking array
				active_balls.append(ball)
				# Set ball texture
				var ball_sprite = ball.get_child(0)
				if ball_sprite:
					ball_sprite.texture = BALL_TEXTURES[active_balls.size() - 1 % BALL_TEXTURES.size()]
	
	print("Initial ball count: ", active_balls.size())

func ball_destroyed(ball: RigidBody2D):
	var ball_index = active_balls.find(ball)
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
	Save.save_stars(level_number - 1, star_score)
	level_end.show_win_screen(star_score)	
	level_ended = true
	
func on_cue_shoot():
	cue_ball_active = true
	
func set_cue_ball_inactive():
	cue_ball_active = false
	
func on_cue_ball_stopped():
	call_deferred("set_cue_ball_inactive")

func check_balls_are_moving():
	if cue_ball_active or level_ended:
		return
		
	balls_moving = false
	for ball in active_balls:
		if is_instance_valid(ball) and ball.linear_velocity.length() >= Global.BALL_MOVING_THRESHHOLD:
			balls_moving = true
			break
			
	if balls_moving != prev_balls_moving:
		prev_balls_moving = balls_moving
		if !balls_moving:
			if active_balls.is_empty():
				succeed_level()
			elif shot_counter == cue_balls.size() - 1:
				fail_level()
			else:
				shot_counter += 1
				print("Balls stopped. Remaining balls: ", active_balls.size())
				balls_stopped.emit()

func _physics_process(_delta):
	check_balls_are_moving()
