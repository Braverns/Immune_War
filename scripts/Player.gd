class_name Player extends CharacterBody2D


@export var move_speed: float = 280
@export var jump_velocity: float = -500

@onready var _animated_sprite: AnimatedSprite2D = $AnimatedSprite2D


var can_move = true;
@export var is_dead = false;




func _physics_process(delta: float) -> void:
	if is_dead:
		# Apply gravity without move_and_slide() so it falls freely
		velocity += get_gravity() * delta
		move_and_slide()
		return # Exit the function, bypassing normal physics logic
	
	# Movement
	if not is_on_floor():
		velocity += get_gravity() * delta


	if can_move and Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
		$JumpSFX.play()

	var direction := Input.get_axis("move_left", "move_right");
	if can_move and direction:
		velocity.x = direction * move_speed
	else:
		velocity.x = move_toward(velocity.x, 0, move_speed)

	if velocity.length() > 0:
		move_and_slide()

	# Animation
	var state = [is_on_floor(), velocity.x]
	match state:
		[false, _]:
			_animated_sprite.play("jump")
		[true, var x] when x != 0:
			_animated_sprite.play("run")
		[true, var x] when x == 0:
			_animated_sprite.play("idle")
			
	if (can_move and velocity.x != 0):        
		_animated_sprite.flip_h = velocity.x < 0



func disable_input() -> void:
	set_physics_process(false)
	set_process(false)
	


const KNOCKBACK_DURATION: float = 0.4
const KNOCKBACK_INITIAL_X: float = 200.0
const KNOCKBACK_INITIAL_Y: float = -90.0
const KNOCKBACK_DECAY: float = 14.0  # Higher = faster decay
const KNOCKBACK_GRAVITY_MULTIPLIER: float = 2.0  # Stronger gravity during knockback

func knockback(source_pos: Vector2) -> void:
	var direction = (global_position - source_pos).normalized().x
	can_move = false
	var time := 0.0
	var knockback_velocity := Vector2(direction * KNOCKBACK_INITIAL_X, KNOCKBACK_INITIAL_Y)
	# Knockback physics loop
	while time < KNOCKBACK_DURATION:
		var decay_factor = exp(-KNOCKBACK_DECAY * time)
		velocity.x = knockback_velocity.x * decay_factor
		velocity.y = knockback_velocity.y * decay_factor
		velocity.y += get_gravity().y * get_process_delta_time() * KNOCKBACK_GRAVITY_MULTIPLIER # gravity
		move_and_slide()
		await get_tree().process_frame
		time += get_process_delta_time()
	can_move = true


func play_die_animation() -> void:
	is_dead = true
	$CollisionShape2D.set_deferred("disabled", true)
	collision_layer = 0
	collision_mask = 0
