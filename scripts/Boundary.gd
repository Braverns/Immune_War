extends StaticBody2D

@export var required_kills: int = 3
@onready var collision: CollisionShape2D = get_node_or_null("boundary_1")


func _ready() -> void:
	Global.enemy_killed_changed.connect(_on_enemy_killed_changed)


func _on_enemy_killed_changed(total: int) -> void:
	if total >= required_kills:
		open_boundary()


func open_boundary() -> void:
	if collision == null:
		print("CollisionShape boundary_1 tidak ditemukan di", name)
		return

	if collision.disabled:
		return

	print("Boundary terbuka:", name)
	collision.set_deferred("disabled", true)
