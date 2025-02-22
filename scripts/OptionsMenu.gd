extends PanelContainer

@onready var level_controls = $HBoxContainer/VBoxContainer/LevelControls
@onready var music_slider = $HBoxContainer/VBoxContainer/MusicControls/MusicSlider
@onready var sfx_slider = $HBoxContainer/VBoxContainer/SFXControls/SFXSlider
@onready var toggle_sfx_button = $HBoxContainer/VBoxContainer/SFXControls/ToggleSFXButton
@onready var toggle_music_button = $HBoxContainer/VBoxContainer/MusicControls/ToggleMusicButton
@onready var difficulty_dropdown: OptionButton = $HBoxContainer/VBoxContainer/DifficultyControls/DifficultyDropdown
@onready var resolution_dropdown: OptionButton = $HBoxContainer/VBoxContainer/ResolutionControls/ResolutionDropdown
@onready var reverse_check_box: CheckBox = $HBoxContainer/VBoxContainer/ReverseControls/ReverseCheckBox
@onready var level_end: PanelContainer = $"../LevelEnd"



@onready var level_menu_button = $"../LevelMenuButton"

var from_level = false

var music_volume = 75
var sfx_volume = 75


func _ready():
	self.visible = false
	set_volume_sliders()
	set_difficulty_dropdown()
	set_resolution_dropdown()
	set_reverse_aim_checkbox()
	
func show_from_main_menu():
	self.visible = true
	level_controls.visible = false
	from_level = false
	
	
func show_from_level():
	self.visible = true
	level_controls.visible = true
	level_menu_button.visible = false
	from_level = true
	get_tree().paused = true

func set_volume_sliders():
	if !Sound.music_muted:
		music_slider.set_value_no_signal(Sound.music_volume)
	else:
		music_slider.set_value_no_signal(0)
		toggle_music_button.button_pressed = true
	if !Sound.sfx_muted:
		sfx_slider.set_value_no_signal(Sound.sfx_volume)
	else:
		sfx_slider.set_value_no_signal(0)
		toggle_sfx_button.button_pressed = true
		
func set_difficulty_dropdown():
	difficulty_dropdown.select(Config.guide_line)
	
func set_resolution_dropdown():
	resolution_dropdown.select(Resolution.display_mode)
	
func set_reverse_aim_checkbox():
	if Config.reverse_aim:
		reverse_check_box.button_pressed = true
	
func _on_toggle_sfx_button_toggled(toggled_on):
	Sound.set_sfx_muted(toggled_on)
	set_volume_sliders()
	
func _on_toggle_music_button_toggled(toggled_on):
	Sound.set_music_muted(toggled_on)
	set_volume_sliders()
	
func _on_music_slider_value_changed(value):
	Sound.change_volume("Music", value)
	if value > 0:
		toggle_music_button.button_pressed = false
	else:
		toggle_music_button.button_pressed = true
		
	
func _on_sfx_slider_value_changed(value):
	Sound.change_volume("SFX", value)
	if value > 0:
		toggle_sfx_button.button_pressed = false
	else:
		toggle_sfx_button.button_pressed = true

	
func _on_close_options_button_pressed():
	hide_options_and_save()

func _on_home_button_pressed():
	hide_options_and_save()
	Scene.load_main_menu()
	
func _on_restart_button_pressed():
	hide_options_and_save()
	Scene.reload_current_level()

func hide_options_and_save():
	if from_level:
		level_menu_button.visible = true
	self.visible = false
	Config.save_options()
	get_tree().paused = false

func _on_level_menu_button_pressed():
	if !level_end.visible:
		show_from_level()

func _on_resolution_dropdown_item_selected(index):
	# index 0 for landscape, 1 for portrait
	if index == 0:
		Resolution.set_game_to_landscape()
	if index == 1:
		Resolution.set_game_to_portrait()

func _on_difficulty_dropdown_item_selected(index: int) -> void:
	match(index):
		0: Config.guide_line = Config.AMATEUR
		1: Config.guide_line = Config.PROFESSIONAL
		2: Config.guide_line = Config.MASTER

func _on_reverse_check_box_toggled(toggled_on: bool) -> void:
	Config.reverse_aim = toggled_on
