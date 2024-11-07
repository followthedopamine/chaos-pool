extends Sprite2D

@onready var ball_mask = $".."
@onready var width = ball_mask.texture.get_width() * ball_mask.scale.x
@onready var height = ball_mask.texture.get_height() * ball_mask.scale.y
@onready var ball = $"../.."

var is_cue_ball = false

var initial_offset = offset
const ROLL_SPEED = 0.01

func _ready():
	if ball.name == "CueBall":
		is_cue_ball = true
	
func roll_with_velocity():
	var vel = ball.linear_velocity

	# Wrap around the texture horizontally
	if offset.x > width / 2:
		offset.x -= width
	elif offset.x < -width / 2:
		offset.x += width

	# Wrap around the texture vertically
	if offset.y > height / 2:
		offset.y -= height
	elif offset.y < -height / 2:
		offset.y += height

	# Update the offset based on velocity
	offset += Vector2(vel.x * ROLL_SPEED, vel.y * ROLL_SPEED)
	
func reset_offset():
	offset = Vector2.ZERO

func _process(_delta):
	# Keep this in regular process to avoid extra speed from physics frames
	if is_cue_ball and ball.cue_ball_type != 0:
		reset_offset()
		return
	roll_with_velocity()
	
func _physics_process(_delta):
	rotation = ball.rotation
