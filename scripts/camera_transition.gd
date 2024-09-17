extends Camera2D

@export var room_size := Vector2 (160, 144)
@export var transition_speed = 4.5

var target_position = Vector2 (0, 0)

func _on_area_2d_camera_room_transition(movement_direction):
	target_position += room_size * movement_direction
	force_move_player.emit(movement_direction)

func _physics_process(delta):
	position = position.lerp(target_position, delta * transition_speed) 

signal force_move_player(Vector2)
