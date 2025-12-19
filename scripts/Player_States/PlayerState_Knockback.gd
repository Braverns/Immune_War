extends State

@export var duration: float = 0.4
@export var initial_force: Vector2 = Vector2(200.0, -250.0) # Tweaked Y for better hop
@export var decay: float = 10.0 # High value for explosion feel

# Helper var easier access to player properties / functions
var player: PlayerWithFSM

# Knockback properties
var timer: float = 0.0
var source_position: Vector2 = Vector2.ZERO
var knockback_dir: int = 1

# Optional: For visual feedback (blinking)
var blink_timer: float = 0.0
var blink_interval: float = 0.08
var blink_on: bool = true


func enter() -> void:
	player = entity as PlayerWithFSM
	timer = 0.0
	blink_timer = 0;

	# Calculate direction based on source
	knockback_dir = 1 if (player.global_position.x - source_position.x) > 0 else -1
	
	# Apply initial explosion force
	player.velocity.x = knockback_dir * initial_force.x
	player.velocity.y = initial_force.y
	
	player.animated_sprite.play("jump") # Or a "hurt" animation
	player.hurt_sfx.play()

	# Optional: Flash red
	_set_blink_state(true)



func exit() -> void:
	player.velocity.x = 0 # Stop sliding when recovered
	player.modulate = Color(1, 1, 1) # Reset color



func physics_update(delta: float) -> void:
	timer += delta
	
	# Apply Gravity (Heavy gravity for knockback feels good)
	player.apply_gravity(delta, 1.5)
	
	# Exponential Decay (Explosion logic) on X axis
	player.velocity.x = lerp(player.velocity.x, 0.0, decay * delta)
	
	player.move_and_slide()
	_update_blink(delta)
	
	# Check Transition
	if timer >= duration:
		if player.is_on_floor():
			player.state_machine.change_state("Idle")
		else:
			player.state_machine.change_state("Jump") # Fall state



func _update_blink(delta: float) -> void:
	blink_timer += delta
	if blink_timer >= blink_interval:
		blink_timer = 0.0
		blink_on = not blink_on
		_set_blink_state(blink_on)



func _set_blink_state(on: bool) -> void:
	if on:
		player.modulate = Color(18.892, 18.892, 18.892) # White, with overbright
	else:
		player.modulate = Color(1, 1, 1, 0.2) # Transparent
