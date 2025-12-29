class_name PlayerWithFSM extends CharacterBody2D

# :: Properties ::
@export var move_speed: float = 300.0
@export var jump_velocity: float = -500.0

#✅ NYIMPAN ARAH TERAKHIR AIM (HORIZONTAL ONLY, BY DEFAULT KE KANAN)
var last_aim_direction: Vector2 = Vector2.RIGHT

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var jump_sfx: AudioStreamPlayer = $JumpSFX
@onready var hurt_sfx: AudioStreamPlayer = $HurtSFX
@onready var state_machine: StateMachine = $StateMachine

@onready var bullet_pool = $BulletPool

var is_dead: bool = false
var direction: float = 1.0

# :: Lifecycle ::
func _ready() -> void:
	state_machine.init(self)


func _physics_process(delta: float) -> void:
	state_machine.physics_update(delta)


func _process(delta: float) -> void:
	state_machine.update(delta)

	if Input.is_action_just_pressed("shoot"):
		shoot()


# :: Helper for states to access gravity ::
func apply_gravity(delta: float, multiplier: float = 1.0) -> void:
	velocity += get_gravity() * multiplier * delta


# :: Wrapper to be called by external hazards ::
func apply_knockback(source_pos: Vector2) -> void:
	var knockback_state = state_machine.get_state_by_name("Knockback")
	if knockback_state:
		knockback_state.source_position = source_pos
		state_machine.change_state("Knockback")


# :: Helper Methods ::
func disable_input() -> void:
	state_machine.change_state("NoControl")


func kill() -> void: 
	state_machine.change_state("NoControl")


func bounce() -> void:
	velocity.y = jump_velocity * 0.5
	animated_sprite.play("jump")



func aim_direction() -> Vector2:
	var dir := Vector2.ZERO

	if Input.is_action_pressed("aim_left"):
		dir.x -= 1
	if Input.is_action_pressed("aim_right"):
		dir.x += 1
	if Input.is_action_pressed("aim_up"):
		dir.y -= 1
	if Input.is_action_pressed("aim_down"):
		dir.y += 1

	# JIKA SEDANG AIM (DITAHAN)
	if dir != Vector2.ZERO:
		last_aim_direction = dir.normalized()
		return last_aim_direction

	# JIKA DILEPAS → IKUT ARAH SPRITE
	var facing_dir := 1.0
	if animated_sprite.flip_h:
		facing_dir = -1.0

	last_aim_direction = Vector2(facing_dir, 0)
	return last_aim_direction


func shoot() -> void:
	var bullet = await bullet_pool.spawn()
	if bullet:
		bullet.launch(global_position, aim_direction())
