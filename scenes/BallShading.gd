extends Sprite2D

@onready var ball = $".."

func _physics_process(_delta):
	rotation = -ball.rotation
