extends Node2D

@onready var main_scene = $"../Main"
const PERMANENT_SCENES = ["DebugPower", "Camera2D"]
const LEVEL_1 = preload("res://scenes/Level_2.tscn")

func load_level_1():
	unload_scenes()
	var scene_instance = LEVEL_1.instantiate()
	main_scene.add_child(scene_instance)

func unload_scenes():
	for child in main_scene.get_children():
		if !child.name in PERMANENT_SCENES:
			child.queue_free()
