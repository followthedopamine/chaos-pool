extends Node2D

var config_path = "user://config.cfg"

var volumes = [75,75]  # [Music, SFX]
var muteds = [false, false] # [Music, SFX]
enum {
	AMATEUR,
	PROFESSIONAL,
	MASTER
}
var guide_line = PROFESSIONAL

func _ready():
	load_options()

func save_options():
	volumes = [Sound.music_volume, Sound.sfx_volume]
	muteds = [Sound.music_muted, Sound.sfx_muted]
	var file = FileAccess.open(config_path, FileAccess.WRITE)
	file.store_var(volumes)
	file.store_var(muteds)
	
func load_options():
	if FileAccess.file_exists(config_path):
		var file = FileAccess.open(config_path, FileAccess.READ)
		volumes = file.get_var()
		muteds = file.get_var()
		Sound.change_volume("Music", volumes[0])
		Sound.change_volume("SFX", volumes[1])
		Sound.music_muted = muteds[0]
		Sound.sfx_muted = muteds[1]
	else:
		print("No config saved")
