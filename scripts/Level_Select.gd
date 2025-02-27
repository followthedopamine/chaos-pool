extends Control

@onready var button_container = $Container/Panel/BoxContainer
signal button_disabled

const LEVEL_BUTTON = preload("res://scenes/Level_Button.tscn")
@onready var vertical_container = $Container/Panel/BoxContainer
@onready var horizontal_container = $Container/Panel/BoxContainer/MarginContainer/BoxContainer
@onready var margin_container = $Container/Panel/BoxContainer/MarginContainer

@onready var return_button = $ReturnButton

const LANDSCAPE_MAX_BUTTONS_PER_ROW = 5
const PORTRAIT_MAX_BUTTONS_PER_ROW = 4

#First 5 should go to first row unless in portrait mode then first 4
func create_level_buttons():
	var total_levels = Scene.LEVELS.size()
	var current_row = horizontal_container
	
	var max_buttons_per_row = 0
	
	if Resolution.display_mode == Resolution.PORTRAIT:
		max_buttons_per_row = PORTRAIT_MAX_BUTTONS_PER_ROW
	else:
		max_buttons_per_row = LANDSCAPE_MAX_BUTTONS_PER_ROW
	
	print("Max buttons per row = %s" % max_buttons_per_row)
	
	for i in range(1, total_levels + 1):
		# Create a new row when needed
		if (i - 1) % max_buttons_per_row == 0:
			var new_margin = margin_container.duplicate()
			vertical_container.add_child(new_margin)
			current_row = new_margin.get_node("BoxContainer")
			# Not a super elegant solution should just copy an empty box
			for n in current_row.get_children():
				current_row.remove_child(n)
				n.queue_free()
		
		var level_button = LEVEL_BUTTON.instantiate()
		current_row.add_child(level_button)
		var level_button_text = level_button.get_child(0)
		level_button_text.text = "[center]%s[/center]" % i

func lock_levels():
	var count = 0
	for button in margin_container.get_children():
		if count == 0:
			count += 1
			continue
		if Save.stars[count - 1] == 0:
			button.disabled = true
			button.get_child(2).visible = true #IMPORTANT: This is what displays the lock
		count += 1
		
func _on_button_pressed():
	Scene.load_level_1()
	
func _on_return_pressed():
	Scene.load_main_menu()

func _ready():
	return_button.connect("pressed", _on_return_pressed)
	Save.load_stars()
	create_level_buttons()
	lock_levels()
