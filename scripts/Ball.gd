extends RigidBody2D

const VOLUME_MULTIPLIER = 0.13
const VOLUME_OFFSET = -30
const LOUD_CLACK = preload("res://sounds/LoudClack.mp3")

var prev_frame_velocity

func _ready():
	connect("body_entered", _on_body_entered)

func play_clack(volume):
	var volume_db = min(VOLUME_OFFSET + volume * VOLUME_MULTIPLIER, 0)
	Sound.create_sound_and_play(LOUD_CLACK, volume_db, self)

func _on_body_entered(body):
	Sound.ball_collision_sound(prev_frame_velocity, body)
	if body.is_in_group("balls"):
		if body != self:
			play_clack(body.prev_frame_velocity.length())

func _physics_process(_delta):
	prev_frame_velocity = linear_velocity
