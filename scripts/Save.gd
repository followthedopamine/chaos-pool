extends Node2D

var save_path = "user://level_data.save"
var stars = [] # Needs to be the length of the amount of levels (fill(0)?)

func _ready():
	populate_stars_array()

func populate_stars_array():
	for i in range(0, Scene.LEVELS.size()):
		stars.append(0)

func save_stars(index, number_of_stars):
	if number_of_stars > stars[index]:
		stars[index] = number_of_stars
		var file = FileAccess.open(save_path, FileAccess.WRITE)
		file.store_var(stars)
	
func load_stars():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		var stars_on_file = file.get_var()
		if stars_on_file.size() < stars.size():
			var stars_difference = stars.size() - stars_on_file.size()
			for i in range(0, stars_difference):
				stars_on_file.append(0)
		stars = stars_on_file
		print("Stars saved on file: " + str(stars))
	else:
		print("No data saved")

func reset_stars():
	for star in stars:
		star = 0
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(stars)
