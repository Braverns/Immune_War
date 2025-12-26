extends Node2D

@export var enemy_scene: PackedScene
@export var enemy_config: EnemyConfig
@export var spawn_count := 2
@export var spawn_interval := 3.0

@onready var timer: Timer = $Timer

var spawned := 0
var active := false

func _ready():
	timer.wait_time = spawn_interval
	timer.one_shot = false
	timer.stop()

	if not timer.timeout.is_connected(_on_timer_timeout):
		timer.timeout.connect(_on_timer_timeout)

func activate():
	if active:
		return

	#print("[Spawner] AKTIF")
	active = true
	spawned = 0

	# SPAWN PERTAMA LANGSUNG
	_spawn_enemy()

	# Kalau masih ada sisa enemy → pakai timer
	if spawned < spawn_count:
		timer.start()

func _on_timer_timeout():
	#print("[Spawner] TIMER TIMEOUT | spawned:", spawned)

	if spawned >= spawn_count:
		timer.stop()
		#print("[Spawner] SELESAI")
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

	#print("[Spawner] ENEMY SPAWN KE-", spawned, "DI:", ene.global_position)
