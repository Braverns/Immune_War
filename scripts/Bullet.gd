class_name Bullet extends Area2D

@export var speed = 600
@export var lifetime = 0.3

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
	physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_OFF

	# 🔥 SPEED BERDASARKAN MODE
	speed = Global.MUTATION_BULLET_SPEED if Global.is_mutation_active else Global.NORMAL_BULLET_SPEED

	currentSpeed = speed
	direction = dir.normalized()
	global_position = target_pos
	
	remainingLifetime = lifetime
	_frames_since_spawn = 0
	
	visible = true
	set_physics_process(true)
	set_process(true)
	$CollisionShape2D.set_deferred("disabled", false)
	rotation = direction.angle()

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Enemy"):
		Global.enemy_damaged.emit(body, 1)
		kill()

	elif body.is_in_group("Medkit"):
		kill()  # pil akan handle spawn heart sendiri

	# Jika kena Dinding (TileMap) atau Lantai (StaticBody)
	#elif body is TileMapLayer or body is StaticBody2D:
		#kill()
	elif body is StaticBody2D:
		kill()
