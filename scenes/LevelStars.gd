extends TextureRect

@onready var level_button_text = $"../LevelButtonText"

const STAR_REGIONS = [18, 210, 306, 402]
const DEFAULT_REGION = [18, 68, 60, 18]

func get_stars():
	var index = int(level_button_text.text) - 1
	var number_of_stars = max(Save.stars[index], STAR_REGIONS.size() - 1)
	texture.region = Rect2(STAR_REGIONS[number_of_stars], DEFAULT_REGION[1], DEFAULT_REGION[2], DEFAULT_REGION[3])

func _ready():
	call_deferred("get_stars")
