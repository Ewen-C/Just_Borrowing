extends Node

@onready var timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("select") : timer.start()
	if Input.is_action_just_released("select") : timer.stop()

func _on_timer_timeout():
	get_tree().quit()
