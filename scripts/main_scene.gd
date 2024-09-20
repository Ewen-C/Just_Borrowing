extends Node2D

@onready var pause_menu = $"UI/Pause Menu"
@onready var game_manager = $GameManager

func _ready():
	get_tree().paused = false
	pause_menu.hide()


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("action_start") : toogle_pause()
	
func toogle_pause() -> void: 
	get_tree().paused = !get_tree().paused
	if get_tree().paused: 
		pause_menu.show();
		pause_menu.current_items = game_manager.item_list
	else: pause_menu.hide()
