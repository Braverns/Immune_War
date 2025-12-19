extends Node

## Preloads ----------------------------------------------

const menuScene = preload("res://scenes/Home.tscn")


## Scene Loader ----------------------------------------------

func loadMenuScene():
	loadScene(menuScene)


func loadLevelScene(level: int):
	var levelScenePath = "res://scenes/levels/level_" + str(level) + ".tscn"
	var levelScene = load(levelScenePath) as PackedScene
	loadScene(levelScene)


func reloadCurrentLevelScene():
	get_tree().reload_current_scene()
	

func loadScene(scene: PackedScene):
	get_tree().change_scene_to_packed(scene)
