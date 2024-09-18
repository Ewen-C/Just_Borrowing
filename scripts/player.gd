extends CharacterBody2D

const TILE_SIZE = 8

@export var walk_speed = 7.5

@onready var animated_sprite = $AnimatedSprite2D
@onready var raycast = $RayCast2D

var is_moving = false
var start_movement_position = Vector2(0, 0)
var movement_direction = Vector2(0, 0)
var percent_to_next_tile = 0.0
var nb_auto_movements = 0

func _physics_process(delta):
	if !is_moving :
		process_new_input()
	elif movement_direction != Vector2.ZERO :
		move_player(delta)
		
func process_new_input() :
	if !nb_auto_movements :
		if !movement_direction.y : movement_direction.x = Input.get_axis("move_left", "move_right")
		if !movement_direction.x : movement_direction.y = Input.get_axis("move_up", "move_down")
	
	if movement_direction != Vector2.ZERO :
		# TODO : Walk animation at half speed instead of Idle
		if !raycast_check_movement() : animated_sprite.play("Idle"); return; 
		
		start_movement_position = position
		is_moving = true
		
		if movement_direction.x != 0 : animated_sprite.play("Walk_Right")
		elif movement_direction.y == 1 : animated_sprite.play("Walk_Down")
		else : animated_sprite.play("Walk_Up")
		
		animated_sprite.flip_h = (movement_direction.x == -1 && raycast_check_movement())
	
func move_player(delta) :
	percent_to_next_tile += walk_speed * delta
	
	if percent_to_next_tile >= 1.0 :
		position = start_movement_position + (TILE_SIZE * movement_direction)
		percent_to_next_tile = 0.0
		
		if nb_auto_movements : 
			nb_auto_movements -= 1
			if nb_auto_movements : process_new_input()
		
		if !nb_auto_movements :
			is_moving = false # Enables new input
			var old_direction = movement_direction
			process_new_input()
			
			if movement_direction == Vector2.ZERO : 
				animated_sprite.play("Idle")
				animated_sprite.flip_h = false
			
			check_new_tile.emit(old_direction) # Signal
		
	else :
		position = start_movement_position + (TILE_SIZE * movement_direction * percent_to_next_tile)

func raycast_check_movement() :
	raycast.target_position = movement_direction * TILE_SIZE
	raycast.force_raycast_update()
	return !raycast.is_colliding()

signal check_new_tile(Vector2)

func _on_camera_force_move_player(in_movement_direction, tiles_to_cross):
	movement_direction = in_movement_direction
	nb_auto_movements = tiles_to_cross
	process_new_input()
