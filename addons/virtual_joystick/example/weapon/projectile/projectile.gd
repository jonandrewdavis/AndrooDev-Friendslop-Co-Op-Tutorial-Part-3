extends Node2D


const SPEED: float = 180.0

var direction: Vector2

func _ready() -> void:
	look_at(global_position + direction)


func _physics_process(delta: float) -> void:
	translate(SPEED * direction * delta)


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
