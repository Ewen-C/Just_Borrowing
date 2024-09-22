extends Camera2D

@export var room_size := Vector2 (160, 144)
@export var transition_speed = 0.7

var target_position = position

func _on_area_2d_camera_room_transition(movement_direction, tiles_to_cross):
	target_position += room_size * movement_direction
	var tween = create_tween()
	tween.tween_property(self, "position", target_position, transition_speed)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	force_move_player.emit(movement_direction, tiles_to_cross)

signal force_move_player(Vector2, int)
