extends Control

@onready var v_box_container = $VBoxContainer

var current_items = {}


# Reacreate labels with each _on_draw (to update strikethough)
func _on_draw():
	for item in current_items :
		var my_label = RichTextLabel.new()
		my_label.fit_content = true
		if current_items[item] : my_label.push_strikethrough()
		my_label.append_text(item)
		my_label.add_theme_font_override("normal_font", load("res://assets/fonts/Quinquefive-ALoRM.ttf"))
		my_label.add_theme_font_size_override("normal_font_size", 5)
		my_label.add_theme_color_override("default_color", "#0f380f")
		v_box_container.add_child(my_label)

func _on_hidden():
	for labels_items in v_box_container.get_children() :
		labels_items.queue_free()
