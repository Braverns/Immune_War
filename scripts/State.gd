class_name State extends Node

# The entity this state controls (Player, Enemy, Level, etc.)
# We type it as 'Node' so it can be anything.
var entity: Node 

# Reference to the machine so states can request transitions
var state_machine: StateMachine

func enter() -> void:
	pass

func exit() -> void:
	pass

func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	pass