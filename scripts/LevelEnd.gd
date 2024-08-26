extends Panel

const LEVEL_CLEARED = preload("res://images/ui/level-cleared/Level Cleared.png")
const LEVEL_FAILED = preload("res://images/ui/level-cleared/Level Failed.png")

@onready var level_finish_texture = $VBoxContainer/LevelFinishTexture
@onready var ad_button = $VBoxContainer/HBoxContainer3/AdButton
@onready var stars_texture = $VBoxContainer/HBoxContainer2/StarsTexture

const STARS_ATLAS = Rect2(0, 0, 160, 39)

const STARS_XS = [
	0,
	160,
	320,
	480,
	540,
]

func show_win_screen(stars):
	self.visible = true
	level_finish_texture.texture = LEVEL_CLEARED
	stars_texture.texture.region = Rect2(STARS_XS[min(stars,STARS_XS.size()-1)], 
										STARS_ATLAS.position.y,
										STARS_ATLAS.size.x, 
										STARS_ATLAS.size.y)
	ad_button.visible = false
	
func show_loss_screen():
	print("Display loss screen")
	self.visible = true
	level_finish_texture.texture = LEVEL_FAILED
	ad_button.visible = true
