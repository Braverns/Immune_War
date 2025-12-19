class_name Bullet extends Area2D

@export var speed = 600
@export var lifetime = 2.0

var currentSpeed := 0.0
var remainingLifetime : float = 0.0
var _frames_since_spawn = 0

@onready var visibleOnScreenNotifier : VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D


func _ready() -> void:
	visibleOnScreenNotifier.screen_exited.connect(_on_screen_exited)


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
	position += transform.x * currentSpeed * delta
	
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
func launch(target_pos: Vector2, direction: float):
	# 1. FORCE INTERPOLATION OFF
	# This tells the engine: "For right now, ignore all smoothing. Just draw where I say."
	physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_OFF
	currentSpeed = speed if direction >= 0 else -speed

	# 2. Teleport & Setup
	global_position = target_pos
	
	remainingLifetime = lifetime
	_frames_since_spawn = 0
	
	# 3. Enable Logic
	visible = true
	set_physics_process(true)
	set_process(true)
	$CollisionShape2D.set_deferred("disabled", false)

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
