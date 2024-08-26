extends TextureRect

@onready var level_button_text = $"../LevelButtonText"

const STAR_REGIONS = [18, 210, 306, 402]
const DEFAULT_REGION = [18, 68, 60, 18]

func get_stars():
	var index = int(level_button_text.text) - 1
	var number_of_stars = min(Save.stars[index], STAR_REGIONS.size() - 1) 
	self.texture.region = Rect2(STAR_REGIONS[number_of_stars], DEFAULT_REGION[1], DEFAULT_REGION[2], DEFAULT_REGION[3])
	# This is working correctly except if you copy the level button
	# it always takes the last level's stars in list ecause it's overwriting 
	# all the regions every time. To make sure this doesn't happen:
	# after copying the level button convert to control node and 
	# convert back, then create a new atlas texture with the stars
	# TODO: Find a way to make the level stars texture unique with copying
	
func _ready():
	call_deferred("get_stars")
