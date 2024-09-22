extends CharacterBody2D

const TILE_SIZE = 8

@export var walk_speed : float = 3.5
@export var player: CharacterBody2D = null

@onready var nav : NavigationAgent2D = $NavigationAgent2D
@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var raycast : RayCast2D = $RayCast2D
@onready var timer_zone_change : Timer = $TimerZoneChange

enum monster_state { WANDER, CHASE, CAUGHT }

var current_state = monster_state.WANDER
var is_moving = false
var start_movement_position = Vector2.ZERO
var movement_direction = Vector2.ZERO
var percent_to_next_tile = 0.0


func _ready():
	nav.target_position = Vector2.ZERO
	timer_zone_change.start()
	player = get_tree().get_nodes_in_group("player")[0]

func _physics_process(delta):
	if current_state == monster_state.CHASE :
		if !is_moving : process_new_movement()
		elif movement_direction != Vector2.ZERO : move_enemy(delta)

func process_new_movement() -> void :
	nav.target_position = player.position
	var player_direction = (nav.get_next_path_position() - global_position).normalized()
	if player_direction == Vector2.ZERO or not raycast_check_movement() : return
	
	if abs(player_direction.x) > abs(player_direction.y) :
		movement_direction.x = 1 if player_direction.x > 0 else -1
		movement_direction.y = 0
		animated_sprite.play("Walk_Right"); animated_sprite.flip_h = (movement_direction.x == -1)
	else :
		movement_direction.y = 1 if player_direction.y > 0 else -1
		movement_direction.x = 0
		animated_sprite.play("Walk_Down") if player_direction.y > 0 else animated_sprite.play("Walk_Up")

	start_movement_position = position
	is_moving = true
	
func raycast_check_movement() -> bool :
	raycast.target_position = movement_direction * TILE_SIZE
	raycast.force_raycast_update()
	return !raycast.is_colliding()

func move_enemy(delta) -> void :
	percent_to_next_tile += walk_speed * delta
	
	if percent_to_next_tile >= 1.0 :
		position = start_movement_position + (TILE_SIZE * movement_direction)
		percent_to_next_tile = 0.0
		is_moving = false
		process_new_movement()
		
	else :
		position = start_movement_position + (TILE_SIZE * movement_direction * percent_to_next_tile)
	

func _on_visible_on_screen_notifier_2d_screen_entered():
	print_debug("CHASE")
	current_state = monster_state.CHASE
	timer_zone_change.stop()

func _on_visible_on_screen_notifier_2d_screen_exited():
	print_debug("WANDER")
	movement_direction = Vector2.ZERO
	current_state = monster_state.WANDER
	timer_zone_change.start()

func _on_timer_zone_change_timeout():
	print_debug("TIMER ZONE CHANGE")
	# Get new target position
	notify_position()
	timer_zone_change.start()

func notify_position():
	pass; # Print enemy position to UI


func _on_hitbox_body_entered(body):
	if body.is_in_group("player") :
		print_debug("LOSE")
		current_state = monster_state.CAUGHT
		player.is_hidden = true
		player.visible = false
		animated_sprite.play("Lose")
		pass; # Show kill animation then game over screen then restart

func _on_animated_sprite_2d_animation_finished():
	game_over.emit()
	
signal game_over
