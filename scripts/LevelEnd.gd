extends Panel

const LEVEL_CLEARED = preload("res://images/ui/level-cleared/Level Cleared.png")
const LEVEL_FAILED = preload("res://images/ui/level-cleared/Level Failed.png")

@onready var level_finish_texture = $VBoxContainer/LevelFinishTexture
@onready var stars_texture = $VBoxContainer/HBoxContainer2/StarsTexture
@onready var next_level_button = $VBoxContainer/HBoxContainer/NextLevelButton
@onready var ad_container = $VBoxContainer/AdContainer
@onready var time_container = $VBoxContainer/TimeContainer
@onready var static_time_display = $VBoxContainer/TimeContainer/StaticTimeDisplay

var level_timer = null

const STARS_ATLAS = Rect2(0, 0, 160, 39)

const STARS_XS = [
	0,
	160,
	320,
	480,
]

func is_next_level_locked(current_level):
	if Save.stars[current_level] > 0:
		return false
	else:
		return true

func show_win_screen(stars):
	self.visible = true
	level_finish_texture.texture = LEVEL_CLEARED
	var number_of_stars = min(stars,STARS_XS.size() - 1)
	stars_texture.texture.region = Rect2(STARS_XS[number_of_stars], 
										STARS_ATLAS.position.y,
										STARS_ATLAS.size.x, 
										STARS_ATLAS.size.y)
	ad_container.visible = false
	time_container.visible = true
	static_time_display.time_elapsed = level_timer.time_elapsed
	static_time_display.update_numbers()
	if Scene.current_level == Scene.LEVELS.size() - 1:
		next_level_button.disabled = true
	else:
		next_level_button.disabled = false
		
	
func show_loss_screen():
	print("Display loss screen")
	self.visible = true
	level_finish_texture.texture = LEVEL_FAILED
	ad_container.visible = true
	time_container.visible = false
	stars_texture.texture.region = Rect2(STARS_XS[0], 
										STARS_ATLAS.position.y,
										STARS_ATLAS.size.x, 
										STARS_ATLAS.size.y)
	next_level_button.disabled = is_next_level_locked(Scene.current_level)
	
func hide_end_screen():
	self.visible = false

func _on_menu_button_pressed():
	hide_end_screen()
	Scene.load_main_menu()

func _on_replay_button_pressed():
	hide_end_screen()
	Scene.reload_current_level()


func _on_next_level_button_pressed():
	hide_end_screen()
	Scene.load_next_level()


func _on_ad_button_pressed():
	pass # TODO
