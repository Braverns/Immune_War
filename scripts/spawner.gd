extends Node2D

@export var enemy_scene: PackedScene
@export var enemy_config: EnemyConfig
@export var spawn_count := 2
@export var spawn_interval := 3.0

@onready var timer: Timer = $Timer
var spawned := 0

func _ready():
	timer.wait_time = spawn_interval
	timer.one_shot = false
	timer.timeout.connect(_on_timer_timeout)
	timer.start()

func _on_timer_timeout():
	if spawned >= spawn_count:
		timer.stop()
		return

	var ene = enemy_scene.instantiate()
	ene.global_position = global_position

	if enemy_config != null:
		ene.config = enemy_config

	get_tree().current_scene.add_child(ene)
	spawned += 1
