extends State

var player: PlayerWithFSM


func enter() -> void:
	player = entity as PlayerWithFSM
	player.is_dead = true # For external checks if needed
	
	# Falling off screen logic
	# player.velocity = Vector2.ZERO
	# # Disable collisions (from your original script)
	# player.get_node("CollisionShape2D").set_deferred("disabled", true)
	# player.collision_layer = 0
	# player.collision_mask = 0
	
	# Play death animation if you have one
	# player.animated_sprite.play("die")


# func physics_update(delta: float) -> void:
# 	# Just fall off screen
# 	player.apply_gravity(delta)
# 	player.move_and_slide()
