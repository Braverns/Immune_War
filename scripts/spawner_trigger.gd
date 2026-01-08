extends Area2D

@export var spawner_paths: Array[NodePath] = []
var spawners: Array = []

func _ready():
	body_entered.connect(_on_body_entered)

	# Ambil semua spawner dari path
	for path in spawner_paths:
		var spawner = get_node_or_null(path)
		if spawner:
			spawners.append(spawner)
		else:
			push_warning("Spawner tidak ditemukan: %s" % path)

func _on_body_entered(body):
	if body.is_in_group("Player"):
		for spawner in spawners:
			spawner.activate()
		
		queue_free()
