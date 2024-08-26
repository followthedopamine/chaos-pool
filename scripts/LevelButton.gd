extends TextureButton

const TEXT_OFFSET_ON_PRESS = 2

@onready var level_button_text = $LevelButtonText
@onready var original_position = level_button_text.position

func restore_original_position():
	level_button_text.position = original_position

func _on_button_up():
	restore_original_position()

func _on_mouse_exited():
	restore_original_position()

func _on_button_down():
	level_button_text.position += Vector2(0, TEXT_OFFSET_ON_PRESS)

func _on_pressed():
	Scene.load_level_by_index(int(level_button_text.text) - 1)




