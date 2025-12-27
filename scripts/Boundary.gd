extends StaticBody2D

@export var required_kills: int = 3
@onready var collision := $CollisionShape2D


func _ready() -> void:
	# Dengar perubahan jumlah enemy mati
	Global.enemy_killed_changed.connect(_on_enemy_killed_changed)

	# Cek kondisi awal (jaga-jaga kalau enemy sudah mati duluan)
	_check_open(Global._enemy_killed)


func _on_enemy_killed_changed(total: int) -> void:
	_check_open(total)


func _check_open(total: int) -> void:
	if total >= required_kills:
		open_boundary()


func open_boundary() -> void:
	if collision.disabled:
		return
	collision.set_deferred("disabled", true)