extends Area2D

@export var tiles_to_cross = 5

var player_entered = false

func _on_player_check_new_tile(movement_direction):
	if player_entered :camera_room_transition.emit(movement_direction, tiles_to_cross)

func _on_body_entered(_body) : player_entered = true
func _on_body_exited(_body) : player_entered = false

signal camera_room_transition(Vector2, int)
