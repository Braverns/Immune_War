class_name Enemy
extends CharacterBody2D

@export var config: EnemyConfig
var direction = -1  # Mulai bergerak ke kiri
var player
@export var health: int = 5

@export var bullet_enemy_scene: PackedScene
#buat narik bulletenemy.tscn dari inspector 

@onready var floorRayCast: RayCast2D = $FloorRayCast2D


func _ready():
	$HitBox.body_entered.connect(_on_hitbox_body_entered)
	$Timer.timeout.connect(shoot)
	
	Global.enemy_damaged.connect(_on_enemy_damaged)

	var players = get_tree().get_nodes_in_group("Player")
	if players.size() > 0:
		player = players[0]



func _physics_process(delta):
	if config == null:
		push_warning("Enemy spawned WITHOUT config: " + str(self))
		return  # Jangan lanjut kalau config belum ada

	velocity += get_gravity() * delta
	velocity.x = 0

	# Animation
	if $AnimatedSprite2D.sprite_frames.has_animation("idle"):
		$AnimatedSprite2D.play("idle")
	else:
		$AnimatedSprite2D.stop()
		
	if player:
		var dir_to_player = player.global_position.x - global_position.x
		$AnimatedSprite2D.flip_h = dir_to_player > 0
	move_and_slide()

	var is_hit_wall = is_on_wall()
	var is_at_edge = is_on_floor() and not floorRayCast.is_colliding()

	# Cek tabrakan dengan dinding, setelah move_and_slide
	if is_hit_wall or is_at_edge:
		direction *= -1  # Balik arah
		floorRayCast.target_position.x *= -1  # Balik target raycast juga	

func shoot():
	if bullet_enemy_scene == null or player == null:
		return

	var bullet = bullet_enemy_scene.instantiate()
	var dir = (player.global_position - global_position).normalized()

	get_tree().current_scene.add_child(bullet)
	bullet.launch(global_position, dir)
	print("shoot dipanggil")


func _on_hitbox_body_entered(body):
	if body.is_in_group("Player"):
		Global.lose_life(config.damage)
		var hit_player := body as PlayerWithFSM
		hit_player.apply_knockback(global_position)
	


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
	Global.register_enemy_kill(self)
	Global.add_coins(1)
	queue_free()


func _on_enemy_damaged(enemy: Node, damage: int) -> void:
	if enemy != self:
		return
	$HurtSFX.play()
	health -= damage

	if health <= 0:
		die()
