class_name Trophy
extends Area2D


func _ready() -> void:
    body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node) -> void:
    if body.is_in_group("Player"):
        print("Trophy collected! Level Complete!")
        Global.trigger_trophy_collected()
        $AnimatedSprite2D.play("collected")
        # Disable collision to prevent multiple triggers
        $CollisionShape2D.set_deferred("disabled", true) 
        await $AnimatedSprite2D.animation_finished
        queue_free()