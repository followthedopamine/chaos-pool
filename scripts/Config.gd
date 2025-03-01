extends Node2D

var config_path = "user://config.cfg"

var volumes = [75,75]  # [Music, SFX]
var muteds = [false, false] # [Music, SFX]
var window_resolution = Vector2.ZERO
var window_position = Vector2.ZERO
var reverse_aim = false
var fill_screen = true

enum {
	AMATEUR,
	PROFESSIONAL,
	MASTER
}
var guide_line = PROFESSIONAL
var display_mode = Resolution.LANDSCAPE

func _ready():
	load_options()
	
func get_window_vars():
	window_resolution = get_window().size
	window_position = get_window().position

func save_options():
	volumes = [Sound.music_volume, Sound.sfx_volume]
	muteds = [Sound.music_muted, Sound.sfx_muted]
	var file = FileAccess.open(config_path, FileAccess.WRITE)
	get_window_vars()
	display_mode = Resolution.display_mode
	file.store_var(volumes)
	file.store_var(muteds)
	file.store_var(display_mode)
	file.store_var(window_resolution)
	file.store_var(window_position)
	file.store_var(guide_line)
	file.store_var(reverse_aim)
	file.store_var(fill_screen)
	
func load_options():
	if FileAccess.file_exists(config_path):
		var file = FileAccess.open(config_path, FileAccess.READ)
		volumes = file.get_var()
		muteds = file.get_var()
		display_mode = file.get_var()
		if display_mode != null:
			if display_mode == Resolution.PORTRAIT:
				Resolution.set_game_to_portrait()
		window_resolution = file.get_var()
		window_position = file.get_var()
		if window_resolution == null:
			get_window_vars()
		else:
			get_window().size = window_resolution
			get_window().position = window_position
		guide_line = file.get_var()
		if guide_line == null:
			guide_line = PROFESSIONAL
		reverse_aim = file.get_var()
		if reverse_aim == null:
			if OS.get_name() == "Android" or OS.get_name() == "iOS":
				reverse_aim = true
			else:
				reverse_aim = false
		fill_screen = file.get_var()
		if fill_screen == null:
			# This should be whatever we have the default set in godot to
			print("Fill screen is null")
			fill_screen = true 
			get_tree().root.set_content_scale_aspect(Window.CONTENT_SCALE_ASPECT_IGNORE)
		else:
			if fill_screen:
				get_tree().root.set_content_scale_aspect(Window.CONTENT_SCALE_ASPECT_IGNORE)
			else:
				get_tree().root.set_content_scale_aspect(Window.CONTENT_SCALE_ASPECT_KEEP)
		Sound.change_volume("Music", volumes[0])
		Sound.change_volume("SFX", volumes[1])
		Sound.music_muted = muteds[0]
		Sound.sfx_muted = muteds[1]
	else:
		print("No config saved")
