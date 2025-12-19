class_name Coin
extends Area2D


@export var coin_value: int = 1


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		Global.add_coins(coin_value);
		# Opsi A
		# $CoinSFX.play()
		# visible = false
		# $CollisionShape2D.set_deferred("disabled", true)
		# await $CoinSFX.finished
		
		# Opsi B
		queue_free() # Remove coin from scene
