class_name Enemy
extends CharacterBody2D

# =========================
# ENEMY MODE
# =========================
enum EnemyMode {
	STATIC,
	MOVE
}

@export var enemy_mode: EnemyMode = EnemyMode.MOVE
@export var config: EnemyConfig

var direction := -1
var player
@export var health: int = 5

@export var bullet_enemy_scene: PackedScene
@export var dna_scene: PackedScene

@onready var floorRayCast: RayCast2D = $FloorRayCast2D

@export var speed: float = 80

var spawner_owner: Node = null


func _ready():
	$HitBox.body_entered.connect(_on_hitbox_body_entered)
	$Timer.timeout.connect(shoot)
	Global.enemy_damaged.connect(_on_enemy_damaged)

	var players = get_tree().get_nodes_in_group("Player")
	if players.size() > 0:
		player = players[0]

	floorRayCast.enabled = true


func _physics_process(delta):
	if config == null:
		push_warning("Enemy spawned WITHOUT config: " + str(self))
		return

	# =========================
	# GRAVITY
	# =========================
	velocity += get_gravity() * delta

	# =========================
	# MODE LOGIC
	# =========================
	match enemy_mode:
		EnemyMode.STATIC:
			velocity.x = 0

		EnemyMode.MOVE:
			velocity.x = direction * speed

	# =========================
	# ANIMATION
	# =========================
	if $AnimatedSprite2D.sprite_frames.has_animation("idle"):
		$AnimatedSprite2D.play("idle")

	# Hadap ke player (tidak mempengaruhi arah jalan)
	if player:
		var dir_to_player = player.global_position.x - global_position.x
		$AnimatedSprite2D.flip_h = dir_to_player > 0

	# =========================
	# MOVE
	# =========================
	move_and_slide()

	# =========================
	# RAYCAST LOGIC (SEPERTI CONTOH KEDUA)
	# =========================
	if enemy_mode == EnemyMode.MOVE:
		var is_hit_wall = is_on_wall()
		var is_at_edge = is_on_floor() and not floorRayCast.is_colliding()

		if is_hit_wall or is_at_edge:
			direction *= -1
			floorRayCast.target_position.x *= -1


func shoot():
	if bullet_enemy_scene == null or player == null:
		return

	var bullet = bullet_enemy_scene.instantiate()
	var dir = (player.global_position - global_position).normalized()

	get_tree().current_scene.add_child(bullet)
	bullet.launch(global_position, dir)


func _on_hitbox_body_entered(body):
	if body.is_in_group("Player"):
		Global.lose_life(config.damage)
		var hit_player := body as PlayerWithFSM
		hit_player.apply_knockback(global_position)


func die():
	# Cek peluang 40% (0.4)
	if randf() <= 0.6:
		spawn_dna()
	
	Global.register_enemy_kill(self)
	# Global.add_coins(1) # <-- Hapus/Matikan ini karena diganti DNA
	queue_free()
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
		
func spawn_dna():
	# Cek biar gak error kalau lupa isi inspector
	if dna_scene == null:
		return
		
	var dna = dna_scene.instantiate()
	dna.global_position = global_position 
	# Gunakan call_deferred agar aman
	get_tree().current_scene.call_deferred("add_child", dna)
