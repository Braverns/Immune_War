extends Node2D

@export var enemy_scene: PackedScene
@export var enemy_config: EnemyConfig
@export var spawn_count := 2

var spawned := 0
var active := false

func _ready():
	if not Global.enemy_died.is_connected(_on_enemy_died):
		Global.enemy_died.connect(_on_enemy_died)

func activate():
	if active:
		return

	active = true
	spawned = 0
	_spawn_enemy()

func _on_enemy_died(enemy: Node):
	if not active:
		return

	if spawned >= spawn_count:
		return

	_spawn_enemy()

func _spawn_enemy():
	if enemy_scene == null:
		push_error("Enemy Scene BELUM DIISI")
		return

	var ene = enemy_scene.instantiate()
	ene.global_position = global_position
	ene.config = enemy_config

	get_tree().current_scene.call_deferred("add_child", ene)
	spawned += 1 
