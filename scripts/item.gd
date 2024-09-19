extends StaticBody2D

@export var type: Constants.ItemType = Constants.ItemType.LUGGAGE
var player = null


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("action_a") and player :
		item_pickup.emit(type)
		queue_free()

func _on_trigger_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"): player = body

func _on_trigger_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"): player = null

signal item_pickup(type: Constants.ItemType)
