extends Area2D

@export var dna_value: int = 10
var velocity_y: float = 0.0
var is_grounded: bool = false 

func _ready() -> void:
	# Pastikan sinyal tersambung
	body_entered.connect(_on_body_entered)
	# Pastikan monitoring aktif
	monitoring = true

func _physics_process(delta: float) -> void:
	if not is_grounded:
		velocity_y += 900.0 * delta
		position.y += velocity_y * delta

func _on_body_entered(body: Node) -> void:
	# --- BAGIAN PENTING: CEK SIAPA YANG NABRAK ---
	print("⚠️ Benda yang nabrak: ", body.name)
	
	# CARA 1: Cek Class (Paling Praktis)
	if body is Player:
		print("Itu Player (via Class). Ambil DNA.")
		Global.add_dna(dna_value)
		queue_free()
		return

	# CARA 2: Cek Group (Cadangan)
	if body.is_in_group("Player"):
		print("Player (via Group). Ambil DNA.")
		Global.add_dna(dna_value)
		queue_free()
		return
		
	# LOGIKA TANAH
	if body is TileMapLayer or body is StaticBody2D:
		print("🪨 Kena Tanah/Dinding")
		is_grounded = true
		velocity_y = 0
