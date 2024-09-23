extends CharacterBody2D

enum EnemyState{
	IDLE,
	CHASING,
	ROOM_TRANSITION,
	UNAWARE,
	CAUGHT
}

var current_action : EnemyState = EnemyState.IDLE
var current_entrance : int = 1
@onready var animated_sprite : AnimatedSprite2D = $EnemySprite

var room_entrances = {
	0 : Vector2i(0,1),
	1 : Vector2i(2,3),
	2 : Vector2i(4,5),
	3 : Vector2i(6,7),
}

var entrance_locations = {
	0 : Vector2(79, -31),
	1 : Vector2(150, -1),
	2 : Vector2(166, 0),
	3 : Vector2(232, -33),
	4 : Vector2(232, -70),
	5 : Vector2(166, -113),
	6 : Vector2(148, -113),
	7 : Vector2(80, -74)
}

#func set_random_goal():
	

@onready var player = get_tree().root.get_child(1, false).get_child(5, false)

func _ready() -> void:
	var room_timer = get_tree().create_timer(4, true, false, false)
	#room_timer.timeout.connect()

func _physics_process(delta: float) -> void:
	#print(player.position)
	#direction_to_enemy_sprite()
	if current_action == EnemyState.CHASING:
		velocity = Vector2.ZERO.move_toward(position - player.position, -1*1000*delta)
	move_and_slide()

func direction_to_enemy_sprite(direction: Vector2) -> String:
	var sprite_state = 0
	#transfer the vector direction to the direction
	var direction_as_float = atan2(direction.y, direction.x)
	#print(direction_as_float)
	# check through conditions to check where the enemy is facing
	#if(direction_as_float )
	return "REPLACE THIS"

# room rotation logic
func _rotate_room() -> void:
	# do not rotate rooms if chasing player
	if(current_action == EnemyState.CHASING):
		return
	var room_timer = get_tree().create_timer(4, true, false, false)
	room_timer.timeout.connect(_rotate_room)

# chase logic
func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	if !player.is_hidden:
		current_action = EnemyState.CHASING

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	current_action = EnemyState.IDLE
	

# closet logic
func _on_closet_player_visibility_changed(visibility: bool) -> void:
	if visibility:
		if current_action == EnemyState.UNAWARE || current_action == EnemyState.ROOM_TRANSITION:
			current_action = EnemyState.CHASING
	else:
		if current_action == EnemyState.CHASING:
			current_action = EnemyState.UNAWARE

func _on_closet_2_player_visibility_changed(visibility: bool) -> void:
	if visibility:
		if current_action == EnemyState.UNAWARE || current_action == EnemyState.ROOM_TRANSITION:
			current_action = EnemyState.CHASING
	else:
		if current_action == EnemyState.CHASING:
			current_action = EnemyState.UNAWARE


func _on_hitbox_body_entered(body):
	if body.is_in_group("player") :
		print_debug("LOSE")
		current_action = EnemyState.CAUGHT
		player.is_hidden = true
		player.visible = false
		animated_sprite.play("Lose")
		pass; # Show kill animation then game over screen then restart

func _on_animated_sprite_2d_animation_finished():
	if animated_sprite.animation == &"Lose":
		game_over.emit()
	
signal game_over
