extends Node

var sounds_to_free = []

func create_sound_and_play(file, volume_db, parent):
	var sound = AudioStreamPlayer2D.new()
	parent.add_child(sound)
	sound.stream = file
	sound.volume_db = volume_db
	sound.play()
	sounds_to_free.append(sound)

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
