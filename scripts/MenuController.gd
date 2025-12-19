class_name MenuController extends Control

@export var start_button: Button


func _ready() -> void:
	start_button.pressed.connect(_on_start_button_pressed)
	

func _on_start_button_pressed() -> void:
	SceneManager.loadLevelScene(1)
