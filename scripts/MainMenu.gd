extends TextureRect

@onready var options_menu = $"../OptionsMenu"


func _on_start_button_pressed():
	Scene.load_level_select()

func _on_settings_button_pressed():
	options_menu.show_from_main_menu()

func _on_exit_button_pressed():
	get_tree().quit()
