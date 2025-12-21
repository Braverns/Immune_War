extends Node

@export var player: CharacterBody2D
@export var camera_0: PhantomCamera2D
@export var camera_1: PhantomCamera2D

var current_fase: int = 0

func update_current_fase(body, fase_a, fase_b): 
	if body == player: 
		match current_fase: 
			fase_a: current_fase = fase_b 
			fase_b: current_fase = fase_a 
		update_camera()

func update_camera(): 
	var cameras = [camera_0, camera_1]
	for camera in cameras: 
		if camera != null:
			camera.priority = 0
	match current_fase: 
		0: 
			camera_0.priority = 1
		1: 
			camera_1.priority = 1

func _on_fase_0_body_entered(body: Node2D) -> void:
	update_current_fase(body, 0, 1)


func _on_fase_1_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
