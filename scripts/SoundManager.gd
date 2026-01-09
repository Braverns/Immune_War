class_name SoundManager extends Node

#@export var bgm_slider: HSlider
#@export var sfx_slider: HSlider

@onready var bgm : AudioStreamPlayer = $BGM
@onready var coin_sfx: AudioStreamPlayer = $CoinSFX
@onready var enemy_die_sfx: AudioStreamPlayer = $EnemyDieSFX
@onready var box_destroyed_sfx: AudioStreamPlayer = $BoxDestroyedSFX


func _ready() -> void:
	Global.coins_changed.connect(_on_coin_changed)
	Global.enemy_died.connect(_on_enemy_died)
	Global.box_destroyed.connect(_on_box_destroyed)
	bgm.play()

	#bgm_slider.value_changed.connect(_on_bgm_volume_changed)
	#sfx_slider.value_changed.connect(_on_sfx_volume_changed)

	# Init Slider value based on current bus volume
	#var bgm_bus_idx = AudioServer.get_bus_index("BGM")
	#bgm_slider.value = db_to_linear(AudioServer.get_bus_volume_db(bgm_bus_idx))
	#
	#var sfx_bus_idx = AudioServer.get_bus_index("SFX")
	#sfx_slider.value = db_to_linear(AudioServer.get_bus_volume_db(sfx_bus_idx))


func _on_coin_changed(_new_coins: int) -> void:
	coin_sfx.play()


func _on_enemy_died(_enemy: Node, _spawner: Node) -> void:
	enemy_die_sfx.play()



func _on_box_destroyed(_box: Node) -> void:
	box_destroyed_sfx.play()


#func _on_bgm_volume_changed(value: float) -> void:
	#var busIdx = AudioServer.get_bus_index("BGM")
	#AudioServer.set_bus_volume_db(busIdx, linear_to_db(value))
	#AudioServer.set_bus_mute(busIdx, value <= 0.01)
#
#
#func _on_sfx_volume_changed(value: float) -> void:
	#var busIdx = AudioServer.get_bus_index("SFX")
	#AudioServer.set_bus_volume_db(busIdx, linear_to_db(value))
	#AudioServer.set_bus_mute(busIdx, value <= 0.01)
