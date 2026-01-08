extends Node

# ==================================================
# CONSTANTS
# ==================================================
const COINS_FOR_LIFE = 10
const STARTING_LIVES = 3
const STARTING_COINS = 0

# ==================================================
# BACKING VARIABLES
# ==================================================
var _coins: int = STARTING_COINS
var _lives: int = STARTING_LIVES
var _enemy_killed: int = 0

# ==================================================
# PROPERTIES
# ==================================================
var coins: int:
	get:
		return _coins
	set(value):
		if _coins == value:
			return
		_coins = value
		coins_changed.emit(_coins)

var lives: int:
	get:
		return _lives
	set(value):
		if _lives == value:
			return
		_lives = value
		lives_changed.emit(_lives)

var next_level: int = 2

# ==================================================
# SIGNALS
# ==================================================
signal coins_changed(new_coins)
signal lives_changed(new_lives)
signal game_over()
signal trophy_collected()
signal enemy_died(enemy: Node, spawner: Node)
signal box_destroyed(box: Node)
signal enemy_damaged(enemy: Node, damage: int)
signal enemy_killed_changed(total: int)

signal mutation_started
signal mutation_ended

# ==================================================
# CORE GAME FUNCTIONS
# ==================================================
func add_life(amount: int = 1) -> void:
	lives += amount

func lose_life(amount: int = 1) -> void:
	lives -= amount
	if lives <= 0:
		game_over.emit()

func reset():
	coins = STARTING_COINS
	lives = STARTING_LIVES
	mutation_points = 0
	is_mutation_active = false
	mutation_ammo = 0

func reset_lives():
	lives = STARTING_LIVES

func trigger_trophy_collected() -> void:
	trophy_collected.emit()

func register_enemy_kill(enemy: Node) -> void:
	_enemy_killed += 1
	enemy_killed_changed.emit(_enemy_killed)

	# call wave
	enemy_died.emit(enemy, enemy.spawner_owner)


# ==================================================
# 🧬 MUTATION SYSTEM (100 COIN)
# ==================================================
var mutation_points := 0
const MUTATION_THRESHOLD := 1 #syarat coin untuk mutasi

var is_mutation_active := false
var mutation_ammo := 0

# ==================================================
# WEAPON CONFIG
# ==================================================
const NORMAL_FIRE_RATE := 0.5
const NORMAL_BULLET_SPEED := 1000

const MUTATION_FIRE_RATE := 0.1
const MUTATION_BULLET_SPEED := 1200
const MUTATION_AMMO_MAX := 45

# ==================================================
# COIN HANDLER (SATU-SATUNYA)
# ==================================================
func add_coins(amount: int) -> void:
	# COIN UNTUK NYAWA
	coins += amount
	if coins >= COINS_FOR_LIFE:
		coins -= COINS_FOR_LIFE
		add_life(1)

	# COIN UNTUK MUTASI
	if not is_mutation_active:
		mutation_points += amount
		if mutation_points >= MUTATION_THRESHOLD:
			start_mutation()

# ==================================================
# MUTATION LOGIC
# ==================================================
func start_mutation():
	is_mutation_active = true
	mutation_ammo = MUTATION_AMMO_MAX
	mutation_points = 0
	mutation_started.emit()
	print("🧬 MUTATION STARTED")

func consume_mutation_ammo():
	if not is_mutation_active:
		return

	mutation_ammo -= 1
	if mutation_ammo <= 0:
		end_mutation()

func end_mutation():
	is_mutation_active = false
	mutation_ended.emit()
	print("🧬 MUTATION ENDED")
