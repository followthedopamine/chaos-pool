extends Panel

const LEVEL_CLEARED = preload("res://images/ui/level-cleared/Level Cleared.png")
const LEVEL_FAILED = preload("res://images/ui/level-cleared/Level Failed.png")

@onready var level_finish_texture = $VBoxContainer/LevelFinishTexture
@onready var ad_button = $VBoxContainer/HBoxContainer3/AdButton
@onready var stars_texture = $VBoxContainer/HBoxContainer2/StarsTexture
@onready var next_level_button = $VBoxContainer/HBoxContainer/NextLevelButton


const STARS_ATLAS = Rect2(0, 0, 160, 39)

const STARS_XS = [
	0,
	160,
	320,
	480,
	540,
]

func is_next_level_locked(current_level):
	if Save.stars[current_level] > 0:
		return false
	else:
		return true

func show_win_screen(stars):
	self.visible = true
	level_finish_texture.texture = LEVEL_CLEARED
	stars_texture.texture.region = Rect2(STARS_XS[min(stars,STARS_XS.size() - 1)], 
										STARS_ATLAS.position.y,
										STARS_ATLAS.size.x, 
										STARS_ATLAS.size.y)
	ad_button.visible = false
	
func show_loss_screen():
	print("Display loss screen")
	self.visible = true
	level_finish_texture.texture = LEVEL_FAILED
	ad_button.visible = true
	if is_next_level_locked(Scene.current_level):
		next_level_button.disabled = true
	
func hide_end_screen():
	self.visible = false

func _on_menu_button_pressed():
	Scene.load_main_menu()

func _on_replay_button_pressed():
	hide_end_screen()
	Scene.reload_current_level()


func _on_next_level_button_pressed():
	hide_end_screen()
	Scene.load_next_level()


func _on_ad_button_pressed():
	pass # TODO
