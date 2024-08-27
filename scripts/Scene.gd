extends Node2D

@onready var main_scene = $"../Main"
const PERMANENT_SCENES = ["DebugPower", "Camera2D", "LevelEnd"]

const LEVELS = [preload("res://scenes/Level_1.tscn"),preload("res://scenes/Level_2.tscn")]

var current_level = 0

func load_main_menu():
	get_tree().reload_current_scene()
	
func reload_current_level():
	load_level_by_index(current_level)
	
func load_next_level():
	load_level_by_index(current_level + 1)

func load_level_1():
	unload_scenes()
	var scene_instance = LEVELS[0].instantiate()
	main_scene.add_child(scene_instance)
	current_level = 1
	
func load_level_by_index(index):
	unload_scenes()
	var scene_instance = LEVELS[index].instantiate()
	main_scene.add_child(scene_instance)
	current_level = index

func unload_scenes():
	for child in main_scene.get_children():
		if !child.name in PERMANENT_SCENES:
			child.queue_free()
