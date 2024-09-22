extends Control

@onready var v_box_container = $VBoxContainer

var current_items = {}
@export var defaut_label : PackedScene

# Reacreate labels with each _on_draw (to update strikethough)
func _on_draw():
	for item in current_items :
		var my_label = defaut_label.instantiate()
		if current_items[item] : my_label.push_strikethrough()
		my_label.append_text(item.replace("_", " "))
		v_box_container.add_child(my_label)

func _on_hidden():
	for labels_items in v_box_container.get_children() :
		labels_items.queue_free()
