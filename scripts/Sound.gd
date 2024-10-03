extends Node

var sounds_to_free = []

var music_volume = 75
var sfx_volume = 75

var music_muted = false
var sfx_muted = false

@onready var music = $"../Main/Music"

const MUSIC_TRACKS = [preload("res://sounds/music/Electro_Breaks_Loop.mp3"),
preload("res://sounds/music/Hovercraft_Two_Point_Oh.mp3"),
preload("res://sounds/music/Mighty_Fine_DnB_Platforming_Completed.mp3"),
preload("res://sounds/music/Nightclub_loop.mp3"),
preload("res://sounds/music/Space _Trap.mp3"),
preload("res://sounds/music/Waypoint_K.mp3")]

const BALL_HITS_TABLE_SOUND = preload("res://sounds/BallHitsWall.mp3")
const BALL_HITS_WOOD_SOUND = preload("res://sounds/Wood.mp3")

func change_track(track_number):
	print("Changing music tracks")
	music.stream = MUSIC_TRACKS[track_number]
	music.play()

func toggle_mute(bus_name):
	match bus_name:
		"Music":
			music_muted = !music_muted
		"SFX":
			sfx_muted = !sfx_muted
	handle_mutes()
			
func handle_mutes():
	var music_index = AudioServer.get_bus_index("Music")
	var sfx_index = AudioServer.get_bus_index("SFX")
	if music_muted:
		AudioServer.set_bus_volume_db(music_index, -1000)
	else:
		AudioServer.set_bus_volume_db(music_index, linear_to_db(music_volume/100))
	if sfx_muted:
		AudioServer.set_bus_volume_db(sfx_index, -1000)
	else:
		AudioServer.set_bus_volume_db(sfx_index, linear_to_db(sfx_volume/100))
		
func set_music_muted(is_muted):
	music_muted = is_muted
	handle_mutes()
	
func set_sfx_muted(is_muted):
	sfx_muted = is_muted
	handle_mutes()

func change_volume(bus_name, volume_percentage):
	match bus_name:
		"Music":
			music_volume = volume_percentage
		"SFX":
			sfx_volume = volume_percentage
	var bus_index = AudioServer.get_bus_index(bus_name)
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(volume_percentage/100))

func create_sound_and_play(file, volume_db, parent):
	var sound = AudioStreamPlayer2D.new()
	parent.add_child(sound)
	sound.bus = "SFX"
	sound.stream = file
	sound.volume_db = volume_db
	sound.play()
	sounds_to_free.append(sound)
	
func ball_collision_sound(prev_frame_velocity, body):
	if body.name == "Table":
		var volume = min(-60 + 0.13 * prev_frame_velocity.length(), 0)
		Sound.create_sound_and_play(BALL_HITS_TABLE_SOUND, volume, body)
	
	if "Wall" in body.name:
		var volume = min(-60 + 0.13 * prev_frame_velocity.length(), 0)
		Sound.create_sound_and_play(BALL_HITS_WOOD_SOUND, volume, body)
		

func _process(_delta):
	var updated_sounds_to_free = []
	for sound in sounds_to_free:
		if is_instance_valid(sound):
			continue
		if !sound.playing:
			sound.queue_free()
		else:
			updated_sounds_to_free.append(sound)
	sounds_to_free = updated_sounds_to_free
