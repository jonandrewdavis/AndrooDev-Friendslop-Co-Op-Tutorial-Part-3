extends FoldableContainer


@export var virtual_joystick: VirtualJoystick

func _ready() -> void:
	if not virtual_joystick:
		return
	
	title = virtual_joystick.name.capitalize()
	%DisabledCheckBox.button_pressed = virtual_joystick.disabled
	%ModeOption.selected = virtual_joystick.mode
	%DirectionOption.selected = virtual_joystick.direction_mode
	
	%BoundarySlider.value = virtual_joystick.boundary
	%DeadzoneSlider.value = virtual_joystick.deadzone
	%VibrationCheckBox.button_pressed = virtual_joystick.vibration_enabled
	%VibrationSlider.value = virtual_joystick.vibration_force
	%EditorCheckBox.button_pressed = virtual_joystick.editor_draw_in_game


func _on_disabled_check_box_pressed() -> void:
	virtual_joystick.disabled = %DisabledCheckBox.button_pressed


func _on_mode_option_item_selected(index: int) -> void:
	var mode_key: StringName = VirtualJoystick.Modes.find_key(index)
	var mode: VirtualJoystick.Modes = VirtualJoystick.Modes[mode_key]
	virtual_joystick.mode = mode


func _on_direction_option_item_selected(index: int) -> void:
	var mode_key: StringName = DirectionUtils.Modes.find_key(index)
	var mode: DirectionUtils.Modes = DirectionUtils.Modes[mode_key]
	virtual_joystick.direction_mode = mode


func _on_boundary_slider_value_changed(value: float) -> void:
	virtual_joystick.boundary = value
	%BoundaryValueLabel.text = str(virtual_joystick.boundary)


func _on_deadzone_slider_value_changed(value: float) -> void:
	virtual_joystick.deadzone = value
	%DeadzoneValueLabel.text = str(virtual_joystick.deadzone)


func _on_vibration_check_box_pressed() -> void:
	virtual_joystick.vibration_enabled = %VibrationCheckBox.button_pressed


func _on_vibration_slider_value_changed(value: float) -> void:
	virtual_joystick.vibration_force = value
	%VibrationValueLabel.text = str(value)


func _on_editor_check_box_pressed() -> void:
	virtual_joystick.editor_draw_in_game = %EditorCheckBox.button_pressed
	virtual_joystick.editor_draw_boundary = %EditorCheckBox.button_pressed
	virtual_joystick.editor_draw_deadzone = %EditorCheckBox.button_pressed
	virtual_joystick.editor_draw_dynamic_area = %EditorCheckBox.button_pressed
