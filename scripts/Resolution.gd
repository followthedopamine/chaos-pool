extends Node2D

enum {
	LANDSCAPE,
	PORTRAIT
}

var display_mode = LANDSCAPE

func set_game_to_portrait():
	display_mode = PORTRAIT
	var width = 360
	var height = 640
	get_window().size = Vector2i(width, height)
	get_window().content_scale_size = Vector2i(width, height)
	adjust_always_loaded_nodes()
	if Scene.main_scene.get_node_or_null("MainMenu") != null:
		print("Attempting to reload main menu")
		Scene.load_main_menu()
	else:
		rotate_level(Scene.current_level_script)
		adjust_level_components(Scene.current_level_script)
		
func set_game_to_landscape():
	display_mode = LANDSCAPE
	var width = 640
	var height = 360
	get_window().size = Vector2i(width, height)
	get_window().content_scale_size = Vector2i(width, height)
	adjust_always_loaded_nodes()
	if Scene.current_level_script == null:
		print("Attempting to reload main menu")
		Scene.load_main_menu()
	else:
		rotate_level(Scene.current_level_script)
		adjust_level_components(Scene.current_level_script)
		
func rotate_level(level):
	if display_mode == PORTRAIT:
		level.global_rotation = deg_to_rad(90)
		level.global_position.x = 360
	else:
		level.global_rotation = deg_to_rad(0)
		level.global_position.x = 0
	for child in level.get_children():
		child.global_position = child.global_position
	
func adjust_level_components(level):
	if display_mode == PORTRAIT:
		level.time.rotation = deg_to_rad(270)
		level.time.global_position.x = 0
	else:
		level.time.rotation = deg_to_rad(0)
		level.time.global_position.x = 0
		level.time.global_position.y = 0
		
		
#func rotate_main_scene():
	#Scene.main_scene.rotation = deg_to_rad(90)
	#Scene.main_scene.position.x = 360
	
func adjust_options():
	var options_menu = Scene.main_scene.get_node("OptionsMenu")
	if display_mode == PORTRAIT:
		options_menu.size = Vector2(360,640)
	else:
		options_menu.size = Vector2(640,360)
		
	
func adjust_level_end():
	var level_end = Scene.main_scene.get_node("LevelEnd")
	if display_mode == PORTRAIT:
		level_end.size = Vector2(360,640)
	else:
		level_end.size = Vector2(640,360)
#func adjust_main_menu(main_menu):
	#main_menu.get_node("Main")
	#pass
	
func adjust_pause_button():
	var pause_button = Scene.main_scene.get_node("LevelMenuButton")
	pause_button.position.x = get_viewport().size.x - pause_button.texture_normal.get_width()
	
# This function should contain all the adjustments that don't depend on
# anything that is ever unloaded for any reason
# Main
# Level End
# Options
func adjust_always_loaded_nodes():
	adjust_options()
	adjust_level_end()
	adjust_pause_button()
	#rotate_main_scene()
	
func _process(delta):
	if display_mode == PORTRAIT:
		# Code for detecting elements that aren't constantly loaded
		pass
		
	
# With the way it works currently we have to make changes to basically every scene.
# The other option is make entirely new scenes for portrait mode and change some of the code.
# Which solution is better?

# Pros of changing every scene
# New scenes will be easier to add in the future

# Pros of making entirely new scenes
# Bug fixing will be much more simple
# The big con of doing it this way is that any new elements added will have to be added
# to both versions of the scenes.
# I think this alone makes doing it in code the right way.

# Had a chat with a bud and it's going to make more sense initially to keep everything
# in one file for now since it's easier to change later
