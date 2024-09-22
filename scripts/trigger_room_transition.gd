extends Area2D

@export var tiles_to_cross = 3

var player_entered = false

const Player = preload("res://scripts/player.gd")

func _ready():
	var player := get_tree().get_first_node_in_group("player") as Player
	player.check_new_tile.connect(_on_player_check_new_tile)

func _on_player_check_new_tile(movement_direction):
	if player_entered :
		camera_room_transition.emit(movement_direction, tiles_to_cross)

func _on_body_entered(body) : if body.is_in_group("player") : player_entered = true
func _on_body_exited(body) : if body.is_in_group("player") : player_entered = false

signal camera_room_transition(Vector2, int)
