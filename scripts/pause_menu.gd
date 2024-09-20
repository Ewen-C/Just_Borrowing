extends Control

@onready var v_box_container = $VBoxContainer

var current_items = {}


func _on_draw():
	for labels_items in v_box_container.get_children() :
		labels_items.queue_free()
	
	for item in current_items :
		print_debug(item)
		print_debug(current_items[item])
