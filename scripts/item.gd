extends StaticBody2D

@export var item_type: Constants.ItemType = Constants.ItemType.LUGGAGE
var player = null

@onready var sprite = $Sprite
@export var normal_sprite : Texture2D
@export var dark_sprite : Texture2D

func _ready():
	sprite.texture = normal_sprite

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("action_a") and player :
		item_pickup.emit(item_type)
		player.amount_of_items += 1
		if player.amount_of_items >= 5:
			player.evac_label.visible = true
		queue_free()

func _on_trigger_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"): player = body
	sprite.texture = dark_sprite

func _on_trigger_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"): player = null
	sprite.texture = normal_sprite

signal item_pickup(item_type: Constants.ItemType)
