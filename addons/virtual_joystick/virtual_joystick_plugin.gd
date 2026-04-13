@tool
extends EditorPlugin


func _enter_tree() -> void:
	add_custom_type(
			"VirtualJoystick", 
			"Control", 
			preload("res://addons/virtual_joystick/virtual_joystick.gd"),
			preload("res://addons/virtual_joystick/virtual_joystick_icon.svg")
	)


func _exit_tree() -> void:
	remove_custom_type("VirtualJoystick")
