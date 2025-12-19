class_name Enemy
extends CharacterBody2D

@export var config: EnemyConfig
var direction = -1  # Mulai bergerak ke kiri

@onready var floorRayCast: RayCast2D = $FloorRayCast2D


func _ready():
	$HitBox.body_entered.connect(_on_hitbox_body_entered)
	$StompZone.body_entered.connect(_on_stompzone_body_entered)


func _physics_process(delta):
	# Terapkan gravitasi
	velocity += get_gravity() * delta
	
	# Gerak horizontal
	velocity.x = direction * config.move_speed
	
	# Animation
	$AnimatedSprite2D.flip_h = direction > 0
	$AnimatedSprite2D.play("run")
	
	move_and_slide()

	var is_hit_wall = is_on_wall()
	var is_at_edge = is_on_floor() and not floorRayCast.is_colliding()

	# Cek tabrakan dengan dinding, setelah move_and_slide
	if is_hit_wall or is_at_edge:
		direction *= -1  # Balik arah
		floorRayCast.target_position.x *= -1  # Balik target raycast juga	



func _on_hitbox_body_entered(body):
	if body.is_in_group("Player"):
		Global.lose_life(config.damage)
		var player := body as PlayerWithFSM
		player.apply_knockback(global_position)


func _on_stompzone_body_entered(body):
	if body.is_in_group("Player"):
		# Cek apakah player sedang jatuh
		if body.velocity.y > 0:
			# Stomp berhasil!
			body.bounce()  # Kita akan tambah ini ke player
			die()


func die():
	# Option A - self manage sequences
	# $HurtSFX.play()
	# visible = false

	# # Disable all collisions
	# $HitBox/HitboxCollisionShape2D.set_deferred("disabled", true)
	# $StompZone/StompzoneCollisionShape2D.set_deferred("disabled", true)
	
	# # Wait until SFX finished then free
	# await $HurtSFX.finished

	# Option B - use global signal
	Global.enemy_died.emit(self)
	queue_free()
