extends Node2D

@onready var main_scene = $"../Main"
@onready var level_menu_buttons = $"../Main/LevelButtons"
@onready var options_menu = $"../Main/OptionsMenu"

const PERMANENT_SCENES = ["Camera2D", "Music", "LevelEnd", "OptionsMenu", "LevelButtons"]

const MAIN_MENU = preload("res://scenes/Main_Menu.tscn")
const MAIN_MENU_PORTRAIT = preload("res://scenes/Main_Menu_Portrait.tscn")

const LEVEL_SELECT = preload("res://scenes/Level_Select.tscn")
const LEVEL_SELECT_PORTRAIT = preload("res://scenes/Level_Select_Portrait.tscn")

const LEVELS = [preload("res://scenes/levels/free/Level_1.tscn"),
				preload("res://scenes/levels/free/Level_2.tscn"),
				preload("res://scenes/levels/free/Level_3.tscn"),
				preload("res://scenes/levels/free/Level_4.tscn"),
				preload("res://scenes/levels/free/Level_5.tscn"),
				]

var current_level = 0
var current_level_script

func hide_level_menu_button():
	level_menu_buttons.visible = false
	
func show_level_menu_button():
	level_menu_buttons.visible = true
	
func restore_options_order():
	var number_of_children = main_scene.get_child_count()
	main_scene.move_child(options_menu, number_of_children)

func load_main_menu():
	unload_scenes()
	hide_level_menu_button()
	var scene_instance = MAIN_MENU.instantiate()
	if Resolution.display_mode == Resolution.PORTRAIT:
		print("Main menu loading in portrait mode")
		scene_instance = MAIN_MENU_PORTRAIT.instantiate()
	main_scene.add_child(scene_instance)
	restore_options_order()
	current_level_script = null
	Sound.change_track(0)

func load_level_select():
	unload_scenes()
	hide_level_menu_button()
	var scene_instance = LEVEL_SELECT.instantiate()
	if Resolution.display_mode == Resolution.PORTRAIT:
		scene_instance = LEVEL_SELECT_PORTRAIT.instantiate()
	main_scene.add_child(scene_instance)
	
func reload_current_level():
	show_level_menu_button()
	unload_scenes()
	await get_tree().create_timer(0.05).timeout
	load_level_by_index(current_level)
	current_level_script.level_reset = true
	
func load_next_level():
	show_level_menu_button()
	load_level_by_index(current_level + 1)

func load_level_1():
	unload_scenes()
	show_level_menu_button()
	var scene_instance = LEVELS[0].instantiate()
	main_scene.add_child(scene_instance)
	current_level = 1
	
func load_level_by_index(index):
	unload_scenes()
	show_level_menu_button()
	var scene_instance = LEVELS[index].instantiate()
	if Resolution.display_mode == Resolution.PORTRAIT:
		Resolution.rotate_level(scene_instance)
	main_scene.add_child(scene_instance)
	current_level = index
	Sound.change_track(current_level + 1)
	print("Loaded level " + str(current_level))

func unload_scenes():
	for child in main_scene.get_children():
		if !child.name in PERMANENT_SCENES:
			child.queue_free()
