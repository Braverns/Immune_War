class_name LevelManager
extends Node


const GAME_OVER_DELAY: float = 0.5



@export var player: PlayerWithFSM
@export var ui_manager: UIManager


func _ready() -> void:
	Global.game_over.connect(_on_game_over)
	Global.trophy_collected.connect(_on_trophy_collected)
	

func _on_game_over() -> void:
	print("Game Over! Restarting level...")
	ui_manager.render_game_over()
	await get_tree().create_timer(GAME_OVER_DELAY).timeout
	player.disable_input()


func _on_trophy_collected() -> void:
	# Handle level completion on collect trophy
	print("Level Completed! Proceeding to next level...")
	ui_manager.render_level_completed()
	await get_tree().create_timer(GAME_OVER_DELAY).timeout
	player.disable_input()
