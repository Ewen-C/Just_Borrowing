extends Node2D

@onready var hint_animation = $AnimationPlayer
@onready var hint_label = $Label
@onready var sprite = $Sprite2D
@onready var animated_sprite = $AnimatedSprite2D

const hide_text = "PRESS A TO HIDE"
const exit_text = "PRESS A TO EXIT"

var player_in_area = false
var player = null
var ongoing_animation = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		hint_label.visible = true
		player_in_area = true
		player = body

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		hint_label.visible = false
		player_in_area = false

signal player_visibility_changed(visibility : bool)

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("action_a") and player_in_area and !ongoing_animation and !player.is_moving :
		sprite.visible = false
		animated_sprite.visible = true
		ongoing_animation = true
		
		if player.is_hidden:
			animated_sprite.play("exit")
		else:
			# First we hide the player sprite and then play the animation
			player.animated_sprite.visible = false
			player.is_hidden = true
			animated_sprite.play("hide")
			#emit a signal for monster
			player_visibility_changed.emit(false)
			

func _on_animated_sprite_2d_animation_finished() -> void:
	# Made like this so we show back the player sprite only after animation finishes
	
	if player.is_hidden and animated_sprite.animation == "exit":
		player.animated_sprite.visible = true
		player.is_hidden = false
		hint_label.text = hide_text
		#emit signal for enemy logic
		player_visibility_changed.emit(true)
	else:
		hint_label.text = exit_text

	sprite.visible = true
	animated_sprite.visible = false
	ongoing_animation = false
