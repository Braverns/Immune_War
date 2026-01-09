class_name Heart
extends Area2D

@export var life_amount: int = 1

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		Global.add_life(life_amount)
		queue_free()
