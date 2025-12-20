class_name UIManager
extends CanvasLayer


@onready var coin_label: Label = %CoinLabel
@onready var lives_label: Label = %LivesLabel

@export var level_completed_panel: Panel
@export var game_over_panel: Panel


func _ready() -> void:
	Global.coins_changed.connect(_on_coins_changed)
	Global.lives_changed.connect(_on_lives_changed)
	
	$GameOverPanel/VBoxContainer/MenuButton.pressed.connect(_on_menu_button_pressed)
	$GameOverPanel/VBoxContainer/ReplayButton.pressed.connect(_on_replay_button_pressed)
	$LevelCompletedPanel/Completed.pressed.connect(_on_next_level_completed_pressed)

	reset_ui()
	


func _on_coins_changed(new_coins: int) -> void:
	coin_label.text = "Coins: %d" % new_coins


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
	# $VolumeContainer.hide()
	level_completed_panel.visible = true


func render_game_over() -> void:
	# $VolumeContainer.hide()
	game_over_panel.visible = true


func reset_ui() -> void:
	_on_coins_changed(Global.coins)
	_on_lives_changed(Global.lives)
	level_completed_panel.visible = false
	game_over_panel.visible = false
	# $VolumeContainer.show()
