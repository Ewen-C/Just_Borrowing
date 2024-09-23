extends Control

var timer : Timer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer = $Timer
	timer.timeout.connect(load_game)
	pass # Replace with function body.

func load_game():
	get_tree().change_scene_to_file("res://scenes/levels/main.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$RichTextLabel.modulate = Color(0,0,0, timer.time_left/ timer.wait_time)
	pass
