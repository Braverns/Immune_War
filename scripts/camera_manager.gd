extends Node

@export var player: CharacterBody2D
@export var camera_0: PhantomCamera2D
@export var camera_1: PhantomCamera2D
@export var camera_2: PhantomCamera2D
@export var camera_3: PhantomCamera2D
@export var camera_4: PhantomCamera2D
@export var camera_5: PhantomCamera2D
@export var camera_6: PhantomCamera2D
@export var camera_7: PhantomCamera2D

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
	if camera_2:
		camera_2.priority = 0
	if camera_3:
		camera_3.priority = 0
	if camera_4:
		camera_4.priority = 0
	if camera_5:
		camera_5.priority = 0
	if camera_6:
		camera_6.priority = 0
	if camera_7:
		camera_7.priority = 0
	

	match current_fase:
		0:
			if camera_0: camera_0.priority = 1
		1:
			if camera_1: camera_1.priority = 1
		2:
			if camera_2: camera_2.priority = 1
		3:
			if camera_3: camera_3.priority = 1
		4:
			if camera_4: camera_4.priority = 1
		5:
			if camera_5: camera_5.priority = 1
		6:
			if camera_6: camera_6.priority = 1
		7:
			if camera_7: camera_7.priority = 1

		-1:
			match last_fase:
				0:
					if camera_0: camera_0.priority = 1
				1:
					if camera_1: camera_1.priority = 1



# ---- FASE 0 ----
func _on_fase_0_body_entered(body: Node2D) -> void:
	if body == player:
		set_fase(0)

func _on_fase_0_body_exited(body: Node2D) -> void:
	if body == player:
		clear_fase(0)


# ---- FASE 1 ----
func _on_selingan_1_body_entered(body: Node2D) -> void:
	if body == player:
		set_fase(1)


func _on_selingan_1_body_exited(body: Node2D) -> void:
	if body == player:
		clear_fase(1)



func _on_fase_2_body_entered(body: Node2D) -> void:
	if body == player:
		set_fase(2)


func _on_fase_2_body_exited(body: Node2D) -> void:
	if body == player:
		clear_fase(2)


func _on_fase_3_body_entered(body: Node2D) -> void:
	if body == player:
		set_fase(3)

func _on_fase_3_body_exited(body: Node2D) -> void:
	if body == player:
		clear_fase(3)
		

func _on_fase_4_body_entered(body: Node2D) -> void:
	if body == player:
		set_fase(4)

func _on_fase_4_body_exited(body: Node2D) -> void:
	if body == player:
		clear_fase(4)

func _on_fase_5_body_entered(body: Node2D) -> void:
	if body == player:
		set_fase(5)

func _on_fase_5_body_exited(body: Node2D) -> void:
	if body == player:
		clear_fase(5)


func _on_selingan_2_body_entered(body: Node2D) -> void:
	if body == player:
		set_fase(6)

func _on_selingan_2_body_exited(body: Node2D) -> void:
	if body == player:
		clear_fase(6)


func _on_selingan_3_body_entered(body: Node2D) -> void:
	if body == player:
		set_fase(7)

func _on_selingan_3_body_exited(body: Node2D) -> void:
	if body == player:
		clear_fase(7)
