extends Sprite2D

@onready var ball = $".."
@export var is_cue_ball = false

func _ready():
	if is_cue_ball:
		ball = ball.get_parent()

func _physics_process(_delta):
	rotation = -ball.rotation
