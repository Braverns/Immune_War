extends State

# Optional: Helper var for cleaner code
var player: PlayerWithFSM

func enter() -> void:
	player = entity as PlayerWithFSM
	player.velocity.x = 0
	player.animated_sprite.play("idle")


func physics_update(_delta: float) -> void:
	player.apply_gravity(_delta)
	player.velocity.x = move_toward(player.velocity.x, 0, player.move_speed)

	# Animation & Movement
	player.animated_sprite.play("idle")
	player.move_and_slide()

	# Check Transitions
	if Input.is_action_just_pressed("jump"):
		player.state_machine.change_state("Jump")
		return
		
	if Input.get_axis("move_left", "move_right"):
		player.state_machine.change_state("Run")
