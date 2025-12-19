extends State

# Optional: Helper var for cleaner code
var player: PlayerWithFSM

func enter() -> void:
	# Safe cast: We know 'entity' is a Player in this context
	player = entity as PlayerWithFSM
	player.animated_sprite.play("run")


func physics_update(delta: float) -> void:
	player.apply_gravity(delta)

	# Now we can use 'player' with full autocomplete
	var direction = Input.get_axis("move_left", "move_right")
	player.direction = direction
	
	# Movement
	if direction:
		player.velocity.x = direction * player.move_speed
		player.animated_sprite.flip_h = direction < 0
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.move_speed)
	
	player.move_and_slide()

	# Sprite Animation
	player.animated_sprite.play("run")
	player.animated_sprite.flip_h = direction < 0

	# Check Transitions
	# Transitioning using the injected state_machine reference
	if Input.is_action_just_pressed("jump"):
		state_machine.change_state("Jump")
	
	if not direction:
		state_machine.change_state("Idle")	