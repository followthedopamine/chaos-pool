extends Node

var sounds_to_free = []

func change_volume(bus_name, volume_percentage):
	var bus_index = AudioServer.get_bus_index(bus_name)
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(volume_percentage/100))

func create_sound_and_play(file, volume_db, parent):
	var sound = AudioStreamPlayer2D.new()
	parent.add_child(sound)
	sound.bus = AudioServer.get_bus_index("SFX")
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
