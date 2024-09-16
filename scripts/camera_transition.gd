extends Camera2D

@export var room_size := Vector2 (160, 144)

var target_position = Vector2 (0, 0)

func _on_area_2d_camera_room_transition(movement_direction):
	target_position = position + room_size * movement_direction
	position = target_position
