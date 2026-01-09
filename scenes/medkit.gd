class_name medkit
extends Area2D

@export var heart_scene: PackedScene   # drag Heart.tscn di Inspector

func _ready():
	#body_entered.connect(_on_body_entered)
	area_entered.connect(_on_area_entered)



func _on_body_entered(body):
	# kalau yang kena adalah Bullet player
	if body is Bullet:
		spawn_heart()
		queue_free()

func spawn_heart():
	if heart_scene:
		var heart = heart_scene.instantiate()
		get_parent().add_child(heart)
		heart.global_position = global_position

func _on_area_entered(area):
	if area is Bullet:
		spawn_heart()
		queue_free()
