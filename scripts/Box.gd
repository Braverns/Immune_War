class_name Box extends StaticBody2D


@export var spawnedObject: PackedScene

@onready var hurtbox: Area2D = $HurtBox
@onready var spawnPoint: Marker2D = $SpawnPoint


func _ready() -> void:
	hurtbox.body_entered.connect(_on_hurtbox_body_entered)


func _on_hurtbox_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		var player := body as PlayerWithFSM
		# Cek apakah player sedang melompat ke atas
		if player.velocity.y <= 0:
			call_deferred("destroy")


func destroy() -> void:
	hurtbox.set_deferred("monitoring", false)
	hurtbox.set_deferred("monitorable", false)

	# Matikan collision fisik Box
	$CollisionShape2D.set_deferred("disabled", true)
	if spawnedObject:
		var instance = spawnedObject.instantiate()
		get_tree().current_scene.add_child(instance)
		instance.global_position = spawnPoint.global_position

	Global.box_destroyed.emit(self)
	$AnimatedSprite2D.play("hit")
	await $AnimatedSprite2D.animation_finished
	queue_free()
