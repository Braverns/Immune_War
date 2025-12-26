extends Area2D

@export var spawner_path: NodePath
@onready var spawner = get_node(spawner_path)

func _ready():
	body_entered.connect(_on_body_entered)
	print("[Trigger] READY")

func _on_body_entered(body):
	print("[Trigger] body masuk:", body.name)

	if body.is_in_group("Player"):
		print("[Trigger] PLAYER TERDETEKSI ✅")
		spawner.activate()
		queue_free()
	else:
		print("[Trigger] BUKAN PLAYER ❌ | groups:", body.get_groups())
