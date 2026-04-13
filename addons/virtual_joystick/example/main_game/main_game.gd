extends Node2D


var right_virtual_joystick_direction: Vector2

func _process(_delta: float) -> void:
	if right_virtual_joystick_direction:
		$Player.aim_weapon(right_virtual_joystick_direction)


func _on_draw() -> void:
	var screen_size_x: float = get_viewport().get_visible_rect().size.x
	$Parallax2D.repeat_times = ceil(screen_size_x*2 / $Parallax2D.repeat_size.x)


func _on_right_virtual_joystick_direction_changed(input_direction: Vector2) -> void:
	right_virtual_joystick_direction = input_direction.normalized()
