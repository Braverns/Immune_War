class_name BulletEnemy extends Area2D

@export var speed = 600
@export var lifetime = 2.0

var currentSpeed := 0.0
var remainingLifetime : float = 0.0
var _frames_since_spawn = 0

# PAKAI VECTOR UNTUK MENGATUR 8 ARAH (HORISONTAL, VERTIKAL, DIAGONAL)
var direction: Vector2 = Vector2.ZERO

@onready var visibleOnScreenNotifier : VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D


func _ready() -> void:
	visibleOnScreenNotifier.screen_exited.connect(_on_screen_exited)

	body_entered.connect(_on_body_entered)


func _on_screen_exited() -> void:
	print("Bullet exited screen, returning to pool")
	# await get_tree().process_frame
	# remainingLifetime = -1


func _physics_process(delta):
	global_position += direction * 400 * delta
	# 4. RE-ENABLE INTERPOLATION (After 1 frame)
	# We wait 1 frame to ensure the "teleport" frame has fully rendered without smoothing.
	if _frames_since_spawn < 2:
		_frames_since_spawn += 1
	elif _frames_since_spawn == 2:
		_frames_since_spawn += 1  # So this block only runs once
		physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_INHERIT
			
	# Normal Movement Logic
	position += direction * currentSpeed * delta
	
	remainingLifetime -= delta
	if remainingLifetime <= 0:
		kill()


# Use this instead of queue_free()
func kill():
	visible = false
	set_physics_process(false)
	set_process(false)
	$CollisionShape2D.set_deferred("disabled", true)


# This function is called by the shooter, NOT the pool
func launch(target_pos: Vector2, dir: Vector2):
	print(dir)
	# 1. FORCE INTERPOLATION OFF
	# This tells the engine: "For right now, ignore all smoothing. Just draw where I say."
	physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_OFF

	# ❌ sebelum (hanya 2-directional shoot)
	# dir -> float
	# currentSpeed = speed if direction >= 0 else -speed

	# ✅ TERBARU (MENDUKUNG 8-DIRECTION SHOOT)
	# dir -> Vector2
	currentSpeed = speed
	direction = dir.normalized()
	
	# 2. Teleport & Setup
	global_position = target_pos
	
	remainingLifetime = lifetime
	_frames_since_spawn = 0
	
	# 3. Enable Logic
	visible = true
	set_physics_process(true)
	set_process(true)
	$CollisionShape2D.set_deferred("disabled", false)

	# Rotasi sprite biar ngarah ke tembakan
	rotation = direction.angle()
	
func _on_body_entered(body: Node) -> void:
	# 1. Cek jika kena Player
	if body.name == "Player" or body.is_in_group("Player"):
		print("Kena Player!")
		# Masukkan logika kurangi nyawa player di sini
		kill()
		
	# 2. Cek jika kena Dinding/Lantai
	elif body is TileMapLayer or body is StaticBody2D:
		kill()

	# :: Option A ::
	# global_position = target_pos
	# currentSpeed = speed if direction > 0 else -speed
	# remainingLifetime = lifetime
	# _frames_since_spawn = 0
	
	# set_physics_process(true)
	# set_process(true)
	# $CollisionShape2D.set_deferred("disabled", false)
	
	# # Delay visibility until after physics has processed the new position
	# await get_tree().physics_frame
	# reset_physics_interpolation()
	# visible = true
