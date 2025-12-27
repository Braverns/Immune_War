extends Node

# :: Constants ::
const COINS_FOR_LIFE = 10
const STARTING_LIVES = 3
const STARTING_COINS = 0

# :: Backing Variables ::
var _coins: int = STARTING_COINS
var _lives: int = STARTING_LIVES
var _enemy_killed: int = 0
# :: Properties ::
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

# :: Signals ::
signal coins_changed(new_coins)
signal lives_changed(new_lives)
signal game_over()
signal trophy_collected()
signal enemy_died(enemy: Node)
signal box_destroyed(box: Node)
signal enemy_damaged(enemy: Node, damage: int)
signal enemy_killed_changed (total: int)

# :: Functions ::
func add_coins(amount: int) -> void:
	coins += amount
	if coins >= COINS_FOR_LIFE:
		coins -= COINS_FOR_LIFE
		add_life(1)

func add_life(amount: int = 1) -> void:
	lives += amount

func lose_life(amount: int = 1) -> void:
	lives -= amount
	if lives <= 0:
		game_over.emit()

func reset():
	coins = STARTING_COINS
	lives = STARTING_LIVES

func reset_lives():
	lives = STARTING_LIVES

func trigger_trophy_collected() -> void:
	trophy_collected.emit()

func register_enemy_kill(enemy: Node) -> void:
	_enemy_killed += 1
	enemy_killed_changed.emit(_enemy_killed)
