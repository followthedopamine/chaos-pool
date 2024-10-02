extends RigidBody2D

const VOLUME_COEFFICIENT = 0.13
const VOLUME_OFFSET = -30
const LOUD_CLACK = preload("res://sounds/LoudClack.mp3")

const BALL_HITS_WALL_SOUND = preload("res://sounds/BallHitsWall.mp3")

var prev_frame_velocity

func _ready():
	connect("body_entered", _on_body_entered)

func play_clack(volume):
	var volume_db = min(VOLUME_OFFSET + volume * VOLUME_COEFFICIENT, 0)
	#print(volume_db)
	Sound.create_sound_and_play(LOUD_CLACK, volume_db, self)

func _on_body_entered(body):
	if body.name == "Table":
		var volume = min(-60 + 0.13 * prev_frame_velocity.length(), 0)
		Sound.create_sound_and_play(BALL_HITS_WALL_SOUND, volume, body)
	#print("Should clack")
	if body.is_in_group("balls"):
		if body != self:
			play_clack(body.prev_frame_velocity.length())

func _physics_process(_delta):
	prev_frame_velocity = linear_velocity

