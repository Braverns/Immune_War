class_name MenuController extends Control

@export var start_button: Button
@export var tutorial_button: Button
@export var settings_button: Button

@export var tutorial_overlay: Control
@export var exit_tutorial_button: Button

@export var settings_overlay: Control
@export var exit_settings_button: Button

@export var bgm_slider: HSlider
@export var sfx_slider: HSlider

func _ready() -> void:
	start_button.pressed.connect(_on_start_button_pressed)
	tutorial_button.pressed.connect(_on_tutorial_button_pressed)
	settings_button.pressed.connect(_on_settings_button_pressed)
	
	exit_tutorial_button.pressed.connect(_on_exit_tutorial_pressed)
	exit_settings_button.pressed.connect(_on_exit_settings_pressed)
	
	tutorial_overlay.visible = false
	settings_overlay.visible = false
	
	setup_sliders()
	
func setup_sliders() -> void:
	var bgm_bus_idx = AudioServer.get_bus_index("BGM")
	var sfx_bus_idx = AudioServer.get_bus_index("SFX")

	bgm_slider.value = db_to_linear(AudioServer.get_bus_volume_db(bgm_bus_idx))
	sfx_slider.value = db_to_linear(AudioServer.get_bus_volume_db(sfx_bus_idx))

	bgm_slider.value_changed.connect(_on_bgm_slider_changed)
	sfx_slider.value_changed.connect(_on_sfx_slider_changed)

func _on_bgm_slider_changed(value: float) -> void:
	var bus_idx = AudioServer.get_bus_index("BGM")
	AudioServer.set_bus_volume_db(bus_idx, linear_to_db(value))
	AudioServer.set_bus_mute(bus_idx, value <= 0.01)

func _on_sfx_slider_changed(value: float) -> void:
	var bus_idx = AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_volume_db(bus_idx, linear_to_db(value))
	AudioServer.set_bus_mute(bus_idx, value <= 0.01)

func _on_start_button_pressed() -> void:
	SceneManager.loadLevelScene(1)

func _on_tutorial_button_pressed() -> void:
	tutorial_overlay.visible = true

func _on_exit_tutorial_pressed() -> void:
	tutorial_overlay.visible = false

func _on_settings_button_pressed() -> void:
	settings_overlay.visible = true

func _on_exit_settings_pressed() -> void:
	settings_overlay.visible = false
