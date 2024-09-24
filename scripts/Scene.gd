extends Node2D

@onready var main_scene = $"../Main"
@onready var level_menu_button = $"../Main/LevelMenuButton"


const PERMANENT_SCENES = ["Camera2D", "LevelEnd", "OptionsMenu", "LevelMenuButton"]

const MAIN_MENU = preload("res://scenes/Main_Menu.tscn")
const LEVEL_SELECT = preload("res://scenes/Level_Select.tscn")

const LEVELS = [preload("res://scenes/Level_1.tscn"),
				preload("res://scenes/Level_2.tscn")]

var current_level = 0
var current_level_script

func hide_level_menu_button():
	level_menu_button.visible = false
	
func show_level_menu_button():
	level_menu_button.visible = true

func load_main_menu():
	unload_scenes()
	hide_level_menu_button()
	var scene_instance = MAIN_MENU.instantiate()
	main_scene.add_child(scene_instance)

func load_level_select():
	unload_scenes()
	hide_level_menu_button()
	var scene_instance = LEVEL_SELECT.instantiate()
	main_scene.add_child(scene_instance)
	
func reload_current_level():
	show_level_menu_button()
	load_level_by_index(current_level)
	
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
	main_scene.add_child(scene_instance)
	current_level = index

func unload_scenes():
	for child in main_scene.get_children():
		if !child.name in PERMANENT_SCENES:
			child.queue_free()
