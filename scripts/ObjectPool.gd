class_name ObjectPool extends Node

@export var scene_to_pool: PackedScene
@export var pool_size: int = 20
@export var expand_if_empty: bool = true

var _pool: Array[Node] = []

func _ready() -> void:
	if not scene_to_pool:
		push_warning("ObjectPool: No scene assigned!")
		return
		
	# 1. Pre-instantiate the pool
	for i in range(pool_size):
		_create_new_object()


func spawn() -> Node:
	# 2. Search for an available (inactive) object
	for obj in _pool:
		# Find an object that is NOT active 
		# (we check our own custom flag or visibility)
		if not obj.visible: 
			return obj # Return it effectively "dead/hidden"
	
	if expand_if_empty:
		return _create_new_object()
	
	return null


func _create_new_object() -> Node:
	var obj = scene_to_pool.instantiate()
	obj.visible = false
	obj.set_process(false)
	obj.set_physics_process(false)
	
	# Add to scene tree
	get_tree().current_scene.add_child.call_deferred(obj) 
	_pool.append(obj) # Add to our tracking array
	return obj
