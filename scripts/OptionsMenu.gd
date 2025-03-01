extends PanelContainer

#@onready var level_controls = $HBoxContainer/VBoxContainer/LevelControls
@onready var music_slider = $HBoxContainer/VBoxContainer/MusicControls/MusicSlider
@onready var sfx_slider = $HBoxContainer/VBoxContainer/SFXControls/SFXSlider
@onready var toggle_sfx_button = $HBoxContainer/VBoxContainer/SFXControls/ToggleSFXButton
@onready var toggle_music_button = $HBoxContainer/VBoxContainer/MusicControls/ToggleMusicButton
#@onready var difficulty_dropdown: OptionButton = $HBoxContainer/VBoxContainer/DifficultyControls/DifficultyDropdown
#@onready var resolution_dropdown: OptionButton = $HBoxContainer/VBoxContainer/ResolutionControls/ResolutionDropdown
@onready var resolution_controls: HBoxContainer = $HBoxContainer/VBoxContainer/ResolutionControls
@onready var difficulty_controls: HBoxContainer = $HBoxContainer/VBoxContainer/DifficultyControls
@onready var aim_controls: HBoxContainer = $HBoxContainer/VBoxContainer/AimControls

@onready var reset_level_confirmation_container: PanelContainer = $ResetLevelConfirmationContainer
@onready var reset_settings_confirmation_container: PanelContainer = $ResetSettingsConfirmationContainer
@onready var reset_times_confirmation_container: PanelContainer = $ResetTimesConfirmationContainer


#@onready var reverse_check_box: CheckBox = $HBoxContainer/VBoxContainer/ReverseControls/ReverseCheckBox
@onready var level_end: PanelContainer = $"../LevelEnd"



@onready var level_menu_button = $"../LevelButtons"

var from_level = false

var music_volume = 75
var sfx_volume = 75


func _ready():
	self.visible = false
	set_volume_sliders()
	set_difficulty_toggle()
	set_resolution_toggle()
	set_reverse_aim_toggle()
	
func show_from_main_menu():
	self.visible = true
	from_level = false
	
	
func show_from_level():
	self.visible = true
	level_menu_button.visible = false
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
		
func set_difficulty_toggle():
	# OLD difficulty_dropdown.select(Config.guide_line)
	# Child 0 Amateur button
	# Child 1 Professional button
	# Child 2 Master button
	difficulty_controls.get_child(Config.guide_line).button_pressed = true
	pass
	
func set_resolution_toggle():
	# OLD resolution_dropdown.select(Resolution.display_mode)
	# Child 0 Landscape button
	# Child 1 Portrait button
	# Child 2 Auto-detect button
	resolution_controls.get_child(Resolution.display_mode).button_pressed = true
	pass
	
func set_reverse_aim_toggle():
	# Child 0 Standard button
	# Child 1 Reverse button
	aim_controls.get_child(Config.reverse_aim).button_pressed = true

		
	
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

func _on_standard_button_pressed() -> void:
	Config.reverse_aim = false

func _on_reverse_button_pressed() -> void:
	Config.reverse_aim = true

func _on_amateur_button_pressed() -> void:
	Config.guide_line = Config.AMATEUR

func _on_professional_button_pressed() -> void:
	Config.guide_line = Config.PROFESSIONAL

func _on_master_button_pressed() -> void:
	Config.guide_line = Config.MASTER

func _on_landscape_button_pressed() -> void:
	Resolution.set_game_to_landscape()

func _on_portrait_button_pressed() -> void:
	Resolution.set_game_to_portrait()

func _on_auto_detect_button_pressed() -> void:
	# TODO: Implement auto-detect
	pass

func _on_level_reset_button_pressed() -> void:
	Scene.reload_current_level()

func _on_level_home_button_pressed() -> void:
	Scene.load_main_menu()


func _on_reset_levels_button_pressed() -> void:
	reset_level_confirmation_container.visible = true

func _on_reset_settings_button_pressed() -> void:
	reset_settings_confirmation_container.visible = true

func _on_reset_times_button_pressed() -> void:
	reset_times_confirmation_container.visible = true

func _on_reset_level_confirm_button_pressed() -> void:
	Save.reset_stars()
	reset_level_confirmation_container.visible = false

func _on_reset_settings_confirm_button_pressed() -> void:
	reset_settings_confirmation_container.visible = false

func _on_reset_times_confirm_button_pressed() -> void:
	reset_times_confirmation_container.visible = false

func _on_reset_cancel_button_pressed() -> void:
	reset_times_confirmation_container.visible = false
	reset_settings_confirmation_container.visible = false
	reset_level_confirmation_container.visible = false
