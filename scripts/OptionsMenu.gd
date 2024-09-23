extends PanelContainer

@onready var level_controls = $HBoxContainer/VBoxContainer/LevelControls


func _ready():
	set_sfx_slider()
	set_music_slider()

func set_sfx_slider():
	pass
	
func set_music_slider():
	pass
	
func toggle_mute_sfx_button():
	pass

func toggle_mute_music_button():
	pass
	
func sfx_slider():
	pass
	
func music_slider():
	pass
	
func show_from_main_menu():
	self.visible = true
	level_controls.visible = false
	
func _on_close_options_button_pressed():
	self.visible = false

func _on_home_button_pressed():
	Scene.load_main_menu()
	
func _on_restart_button_pressed():
	Scene.reload_current_level()
