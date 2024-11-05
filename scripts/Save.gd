extends Node2D

var save_path = "user://level_data.save"
var stars = [0,0,0] # Needs to be the length of the amount of levels (fill(0)?)

func save_stars(index, number_of_stars):
	if number_of_stars > stars[index]:
		stars[index] = number_of_stars
		var file = FileAccess.open(save_path, FileAccess.WRITE)
		file.store_var(stars)
	
func load_stars():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		stars = file.get_var()
		print("Stars saved on file: " + str(stars))
	else:
		print("No data saved")
