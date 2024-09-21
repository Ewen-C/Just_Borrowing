extends Node

var item_list = {}

func _ready():
	for item_type in Constants.ItemType : item_list[item_type] = false

func _process(_delta):
	if Input.is_action_just_pressed("action_select"): get_tree().quit()

func _on_item_item_pickup(new_item_type):
	item_list[Constants.ItemType.keys()[new_item_type]] = true
	print_debug("Collected " + str(Constants.ItemType.keys()[new_item_type]))
