extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	#print("hey")
	if body.is_in_group("player"):
		if body.amount_of_items >= 5:
			call_deferred("load_win_screen")
	pass # Replace with function body.

func load_win_screen():
	get_tree().change_scene_to_file("res://scenes/levels/you_win.tscn")
