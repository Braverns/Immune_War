extends State

var player: PlayerWithFSM

func enter() -> void:
	player = entity as PlayerWithFSM
	player.animated_sprite.play("fall")

func physics_update(delta: float) -> void:
	player.apply_gravity(delta)

	# Air control
	var direction := Input.get_axis("move_left", "move_right")
	player.direction = direction

	if direction != 0:
		player.velocity.x = direction * player.move_speed
		player.animated_sprite.flip_h = direction < 0
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.move_speed)

	player.move_and_slide()

	# Landing
	if player.is_on_floor():
		if direction == 0:
			player.state_machine.change_state("Idle")
		else:
			player.state_machine.change_state("Run")