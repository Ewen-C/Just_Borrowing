extends CharacterBody2D

const TILE_SIZE = 16
@export var walk_speed = 3.0

@onready var animated_sprite = $AnimatedSprite2D
@onready var raycast = $RayCast2D

var is_moving = false
var start_movement_position = Vector2(0, 0)
var movement_direction = Vector2(0, 0)
var percent_to_next_tile = 0.0


func _physics_process(delta):
	if !is_moving :
		process_new_input()
	elif movement_direction != Vector2.ZERO:
		move_player(delta)
		
func process_new_input() :
	if !movement_direction.y : movement_direction.x = Input.get_axis("move_left", "move_right")
	if !movement_direction.x : movement_direction.y = Input.get_axis("move_up", "move_down")
	
	if movement_direction != Vector2.ZERO :
		if !raycast_check_movement() : animated_sprite.play("Idle"); return;
		
		start_movement_position = position
		is_moving = true
		
		if movement_direction.x == 1 : animated_sprite.play("Walk_Right")
		elif movement_direction.x == -1 : animated_sprite.play("Walk_Left")
		elif movement_direction.y == 1 : animated_sprite.play("Walk_Down")
		else : animated_sprite.play("Walk_Up")
	
func move_player(delta) :
	percent_to_next_tile += walk_speed * delta
	
	if percent_to_next_tile >= 1.0 :
		position = start_movement_position + (TILE_SIZE * movement_direction)
		percent_to_next_tile = 0.0
		is_moving = false # Enables new input
		
		process_new_input()
		if movement_direction == Vector2.ZERO : animated_sprite.play("Idle")
		
	else :
		position = start_movement_position + (TILE_SIZE * movement_direction * percent_to_next_tile)

func raycast_check_movement() :
	raycast.target_position = movement_direction * TILE_SIZE
	raycast.force_raycast_update()
	return !raycast.is_colliding()
