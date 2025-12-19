class_name Hazard
extends Area2D

@export var damage: int = 1


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		Global.lose_life(damage)
		var player = body as PlayerWithFSM
		player.apply_knockback(global_position)
