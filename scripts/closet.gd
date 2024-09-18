extends Node2D

@onready var hint_animation = $AnimationPlayer
@onready var hint_label = $Label
@onready var sprite = $Sprite2D
@onready var animated_sprite = $AnimatedSprite2D

const hide_text = "PRESS A TO HIDE"
const exit_text = "PRESS A TO EXIT"

var player_in_area = false
var player = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hint_label.visible = false
	hint_animation.play("bounce")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		hint_label.visible = true
		player_in_area = true
		player = body

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		hint_label.visible = false
		player_in_area = false
		player = body

func _input(event: InputEvent) -> void:
	if event.is_action_released("action_a") and player_in_area:
		sprite.visible = false
		animated_sprite.visible = true
		
		if player.is_hidden:
			animated_sprite.play("exit")
		else:
			player.hide_somewhere()  # First we hide the player sprite and then play the animation
			animated_sprite.play("hide")

func _on_animated_sprite_2d_animation_finished() -> void:
	# Made like this so we show back the player sprite only after animation finishes
	if player.is_hidden and animated_sprite.animation == "exit":
		player.exit_hideout()
		hint_label.text = hide_text
	else:
		hint_label.text = exit_text
		
	sprite.visible = true
	animated_sprite.visible = false
