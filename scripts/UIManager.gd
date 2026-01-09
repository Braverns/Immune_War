class_name UIManager
extends CanvasLayer


@onready var coin_label: Label = %CoinLabel
@onready var lives_label: Label = %LivesLabel
@onready var type_label: Label = %TypeGunLabel
@onready var ammo_label: Label = %AmmoLabel

@export var level_completed_panel: Panel
@export var game_over_panel: Panel


func _ready() -> void:
	Global.coins_changed.connect(_on_coins_changed)
	Global.lives_changed.connect(_on_lives_changed)
	
	Global.mutation_started.connect(_on_mutation_started)
	Global.mutation_ended.connect(_on_mutation_ended)
	Global.mutation_ammo_changed.connect(_on_mutation_ammo_changed)
	
	$GameOverPanel/HBoxContainer/MenuButton.pressed.connect(_on_menu_button_pressed)
	$GameOverPanel/HBoxContainer/ReplayButton.pressed.connect(_on_replay_button_pressed)
	$LevelCompletedPanel/Completed.pressed.connect(_on_next_level_completed_pressed)
	$LevelCompletedPanel/ReplayButton.pressed.connect(_on_replay_button_pressed)
	reset_ui()
	
func _on_coins_changed(new_coins: int) -> void:
	coin_label.text = "DNA : %d" % new_coins


func _on_lives_changed(new_lives: int) -> void:
	lives_label.text = "Lives: %d" % new_lives


func _on_menu_button_pressed() -> void:
	Global.reset_lives()
	SceneManager.loadMenuScene()


func _on_replay_button_pressed() -> void:
	Global.reset_lives()
	SceneManager.reloadCurrentLevelScene()


func _on_next_level_completed_pressed() -> void:
	SceneManager.loadMenuScene()


func render_level_completed() -> void:
	level_completed_panel.visible = true


func render_game_over() -> void:
	game_over_panel.visible = true

func _on_mutation_started() -> void:
	type_label.text = "Type: M.ENZIM"
	ammo_label.text = "Ammo: %d" % Global.MUTATION_AMMO_MAX
	
func _on_mutation_ended() -> void:
	type_label.text = "Type: ENZIM"
	ammo_label.text = "Ammo: ∞"
	
func _on_mutation_ammo_changed(new_ammo: int) -> void:
	if Global.is_mutation_active:
		ammo_label.text = "Ammo: %d" % new_ammo

func reset_ui() -> void:
	_on_coins_changed(Global.coins)
	_on_lives_changed(Global.lives)
	if Global.is_mutation_active:
		_on_mutation_started()
		_on_mutation_ammo_changed(Global.mutation_ammo)
	else:
		_on_mutation_ended()
		

	level_completed_panel.visible = false
	game_over_panel.visible = false
	# $VolumeContainer.show()
