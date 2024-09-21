extends CharacterBody2D

const TILE_SIZE = 8

@export var walk_speed = 5
@export var chase_speed = 6.5
@export var target: Vector2

@onready var nav : NavigationAgent2D = $NavigationAgent2D
@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var raycast : RayCast2D = $RayCast2D
@onready var timer_zone_change : Timer = $TimerZoneChange
@onready var timer_chase : Timer = $TimerChase

var is_waiting = false
var is_chasing_player = false
var is_moving = false


func _ready():
	nav.target_position = Vector2.ZERO
	timer_zone_change.start()

func _physics_process(delta):
	if is_waiting :
		if position.distance_to(target) > 0.5 :
			var direction = (nav.get_next_path_position() - global_position).normalized()
			if direction.x > direction.y :
				print_debug("X") # Tile based movement
			else :
				print_debug("Y") # Tile based movement
		else :
			timer_zone_change.start()

func _on_timer_zone_change_timeout():
	# Get new target position
	notify_position()

func notify_position():
	print_debug("New target : ")
	# Print target position to UI
