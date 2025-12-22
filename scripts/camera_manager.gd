extends Node

@export var player: CharacterBody2D
@export var camera_0: PhantomCamera2D
@export var camera_1: PhantomCamera2D

var current_fase: int = -1
var last_fase: int = -1



func set_fase(fase: int) -> void:
	if current_fase == fase:
		return

	last_fase = current_fase
	current_fase = fase
	update_camera()



func clear_fase(fase: int) -> void:
	# Jangan ganti kamera di exited
	# Hanya clear state
	if current_fase == fase:
		current_fase = -1



func update_camera() -> void:
	# Reset semua priority
	if camera_0:
		camera_0.priority = 0
	if camera_1:
		camera_1.priority = 0

	match current_fase:
		0:
			camera_0.priority = 1
		1:
			camera_1.priority = 1
		-1:
			match last_fase:
				0:
					camera_0.priority = 1
				1:
					camera_1.priority = 1




# ---- FASE 0 ----
func _on_fase_0_body_entered(body: Node2D) -> void:
	if body == player:
		set_fase(0)

func _on_fase_0_body_exited(body: Node2D) -> void:
	if body == player:
		clear_fase(0)


# ---- FASE 1 ----
func _on_fase_1_body_entered(body: Node2D) -> void:
	if body == player:
		set_fase(1)

func _on_fase_1_body_exited(body: Node2D) -> void:
	if body == player:
		clear_fase(1)