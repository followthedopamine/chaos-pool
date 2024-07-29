extends Sprite2D

var roll_speed = 0.01
@onready var ball_mask = $".."
@onready var width = ball_mask.texture.get_width() * ball_mask.scale.x
@onready var height = ball_mask.texture.get_height() * ball_mask.scale.y
@onready var ball = $"../.."

var initial_offset = offset

func _ready():
	ball.apply_central_impulse(Vector2(1500,0))
	#offset = Vector2(17, 0)

func roll_right(delta):
	if offset.x > 24:
		offset = Vector2(initial_offset.x - 24, offset.y)
	offset += Vector2(roll_speed - delta,0)
	
func roll_up(delta):
	if offset.y < -24:
		offset = Vector2(offset.x, initial_offset.y + 24)
	offset -= Vector2(0,roll_speed - delta)
	
#func roll_with_velocity():
	#var vel = ball.linear_velocity
	#if offset.y <= -24:
		#offset = Vector2(offset.x, 23.9)
	#if offset.y >= 24:
		#offset = Vector2(offset.x, -23.9)
	#print(offset)
	## So the problem is... it's setting the offset to the other offset
	#if offset.x > width / 2:
		#offset = Vector2((initial_offset.x - width / 2) + 0.001, offset.y)
	#if offset.x < width / 2:
		#offset = Vector2((initial_offset.x + width / 2) - 0.001, offset.y)
	##offset += Vector2(0, vel.y * roll_speed)
	#offset += Vector2(-vel.x * roll_speed * 5, vel.y * roll_speed)
	
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
	offset += Vector2(vel.x * roll_speed, vel.y * roll_speed)

func move_ball(delta):
	pass
	#ball.linear_velocity = Vector2(50 -delta ,-20 + delta)

func _process(delta):
	move_ball(delta)
	roll_with_velocity()
	#roll_up(delta)
	#roll_right(delta)
	
