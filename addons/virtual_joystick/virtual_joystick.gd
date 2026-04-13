@tool
@icon("res://addons/virtual_joystick/virtual_joystick_icon.svg")
class_name VirtualJoystick
extends Control
## A customizable Virtual Joystick for mobile games.
##
## It manages the control's visual interface, processes user touch input,
## and converts that movement into useful direction vectors for your game.


## Emitted when the input direction changes.
signal direction_changed(input_direction: Vector2)

## Emitted when the virtual joystick starts being pressed.
signal pressed

## Emitted when the virtual joystick is released.
signal released

## Defines the joystick's behavior regarding its position.
enum Modes {
	STATIC, ## Keeps a fixed position.
	DYNAMIC, ## Appears at the touch position and stays there.
	FOLLOWING, ## Appears at the touch position and follows the finger if it moves beyond the boundary.
}

## If [code]true[/code], the virtual joystick is disabled and cannot process inputs.
@export var disabled: bool = false:
	set(value):
		disabled = value
		modulate = Color.DIM_GRAY if disabled else Color.WHITE
		if not is_node_ready():
			await ready
		
		if not Engine.is_editor_hint():
			set_process_input(not disabled)
			if disabled:
				_reset_stick()
				_input_direction = Vector2.ZERO
				_update_input_actions()
				if _is_dynamic_mode():
					_set_dynamic_visibility(0.0)

## Defines the virtual joystick mode.
@export var mode: Modes = Modes.STATIC:
	set(value):
		mode = value
		if not is_node_ready():
			await ready
		
		if not Engine.is_editor_hint():
			%Base.modulate.a = 0.0 if _is_dynamic_mode() else 1.0
			%Stick.modulate.a = 0.0 if _is_dynamic_mode() else 1.0
			if not _is_dynamic_mode():
				global_position = _default_position

## Defines the direction snapping mode (e.g., 2-way, 4-way, 8-way, or 360° Analog).
@export var direction_mode: DirectionUtils.Modes = DirectionUtils.Modes.DIRECTION_360

## Defines the limit of the area that detects touch.
@export_range(1.0, 1.5, 0.01) var boundary: float = 1.2

## Defines the minimum movement threshold required to register a direction.
@export_range(0.0, 0.5, 0.01) var deadzone: float = 0.2:
	set(value):
		deadzone = value
		_set_input_deadzones()

# Dynamic Margin Group
@export_group("Dynamic Area Margin", "dynamic_area")
## Offset for the virtual joystick activation area in mode [constant DYNAMIC]
## or [constant FOLLOWING], from the left edge of the screen (0.0 to 1.0).
@export_range(0.0, 1.0, 0.001) var dynamic_area_left_margin: float = 0.0:
	set(value):
		dynamic_area_left_margin = min(value, dynamic_area_right_margin)

## Offset for the virtual joystick activation area in mode [constant DYNAMIC]
## or [constant FOLLOWING], from the top edge of the screen (0.0 to 1.0).
@export_range(0.0, 1.0, 0.001) var dynamic_area_top_margin: float = 0.0:
	set(value):
		dynamic_area_top_margin = min(value, dynamic_area_bottom_margin)

## Offset for the virtual joystick activation area in mode [constant DYNAMIC]
## or [constant FOLLOWING], from the right edge of the screen (0.0 to 1.0).
@export_range(0.0, 1.0, 0.001) var dynamic_area_right_margin: float = 1.0:
	set(value):
		dynamic_area_right_margin = max(value, dynamic_area_left_margin)

## Offset for the virtual joystick activation area in mode [constant DYNAMIC]
## or [constant FOLLOWING], from the bottom edge of the screen (0.0 to 1.0).
@export_range(0.0, 1.0, 0.001) var dynamic_area_bottom_margin: float = 1.0:
	set(value):
		dynamic_area_bottom_margin = max(value, dynamic_area_top_margin)

# Visual Group
@export_group("Visual")
## The texture used for the virtual joystick base.
@export var base_texture: Texture2D = preload("uid://clc2p1pp5y2lh"):
	set(value):
		base_texture = value
		if not is_node_ready():
			await ready
		
		%Base.texture = base_texture
		%Base.pivot_offset = (
				%Base.texture.get_size() / 2.0 if base_texture
				else Vector2.ZERO
		)
		
		if is_inside_tree():
			update_configuration_warnings()

## The texture used for the virtual joystick stick.
@export var stick_texture: Texture2D = preload("uid://ufha6ls7safh"):
	set(value):
		stick_texture = value
		if not is_node_ready():
			await ready
		
		%Stick.texture = stick_texture
		%Stick.pivot_offset = (
				%Stick.texture.get_size() / 2.0 if stick_texture
				else Vector2.ZERO
		)
		
		if is_inside_tree():
			update_configuration_warnings()

## Global scale of the virtual joystick UI components.
@export_range(0.1, 5.0, 0.001) var joystick_scale: float = 1.0:
	set(value):
		joystick_scale = value
		if not is_node_ready():
			await ready
		%Base.scale = Vector2.ONE * joystick_scale
		%Stick.scale = Vector2.ONE * joystick_scale
		%Base.pivot_offset = %Base.size / 2.0
		%Stick.pivot_offset = %Stick.size / 2.0

# Action Group
@export_group("Action", "action_")
## If [code]true[/code], automatically simulates input actions.
## This allows you to use [method Input.get_vector] in scripts,
## such as the player script.
@export_custom(PROPERTY_HINT_GROUP_ENABLE, "") var action_enabled: bool = true:
	set(value):
		action_enabled = value
		update_configuration_warnings()

## The name of the action associated with leftward movement.
@export_custom(PROPERTY_HINT_INPUT_NAME, "show_builtin") var action_left: StringName = &"ui_left":
	set(value):
		action_left = value
		update_configuration_warnings()

## The name of the action associated with upward movement.
@export_custom(PROPERTY_HINT_INPUT_NAME, "show_builtin") var action_up: StringName = &"ui_up":
	set(value):
		action_up = value
		update_configuration_warnings()

## The name of the action associated with rightward movement.
@export_custom(PROPERTY_HINT_INPUT_NAME, "show_builtin") var action_right: StringName = &"ui_right":
	set(value):
		action_right = value
		update_configuration_warnings()

## The name of the action associated with downward movement.
@export_custom(PROPERTY_HINT_INPUT_NAME, "show_builtin") var action_down: StringName = &"ui_down":
	set(value):
		action_down = value
		update_configuration_warnings()

# Vibration Group
@export_group("Vibration", "vibration_")
## If [code]true[/code], there will be tactile feedback
## with a vibration when directions change.[br]
## [br]
## [b]Note:[/b] This feature is exclusive to [b]mobile devices[/b] (Android / iOS).[br]
## [br]
## [b]Note:[/b] On [b]Android[/b], you must enable the [b]VIBRATE[/b]
## permission in the export settings
## ([code]Project -> Export -> Android -> Permissions -> Vibrate[/code]).[br]
## [br]
## [b]Note:[/b] On [b]iOS[/b], manual permission is not required,
## but feedback depends on the user not being in [i]"Low Power Mode"[/i]
## and having vibrations enabled in system settings.
@export_custom(PROPERTY_HINT_GROUP_ENABLE, "") var vibration_enabled: bool = false

## Defines the vibration intensity.
@export_range(1.0, 2.0, 0.001) var vibration_force: float = 1.0

# Editor Group
@export_group("Editor", "editor_")
## Displays debug visual indicators during gameplay.
@export var editor_draw_in_game: bool = false

## Draws the maximum touch boundary for the virtual joystick in the editor.
@export var editor_draw_boundary: bool = true:
	set(value):
		editor_draw_boundary = value
		queue_redraw()

## Draws the deadzone area in the editor.
@export var editor_draw_deadzone: bool = true:
	set(value):
		editor_draw_deadzone = value
		queue_redraw()

## Draws the activation area for mode [constant DYNAMIC]
## or [constant FOLLOWING] in the editor.
@export var editor_draw_dynamic_area: bool = true:
	set(value):
		editor_draw_dynamic_area = value
		queue_redraw()

# Stores the touch index to track the specific finger interacting with the joystick.
var _touch_index: int = -1

# Original position of the joystick when not in dynamic mode.
var _default_position: Vector2

# Current raw direction vector before snapping.
var _input_direction: Vector2

# Tween used to smoothly return the stick to center.
var _tween_stick: Tween

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: Array[String] = []
	if not base_texture:
		warnings.append("A 'Base Texture' is required for the joystick background to be visible.")
	
	if not stick_texture:
		warnings.append("A 'Stick Texture' is required for the movable stick handle to be visible.")
	
	var base_node = get_node_or_null("%Base")
	if not base_node:
		warnings.append("The scene structure requires a node with the 'Scene Unique Name' set to %Base.")
	elif not base_node is TextureRect:
		warnings.append("The node '%Base' must be a TextureRect to display the base texture.")
	
	var stick_node = get_node_or_null("%Stick")
	if not stick_node:
		warnings.append("The scene structure requires a node with the 'Scene Unique Name' set to %Stick.")
	elif not stick_node is TextureRect:
		warnings.append("The node '%Stick' must be a TextureRect to display the stick texture.")
	
	if action_enabled:
		if (
				action_left == &"" or action_up == &""
				or action_right == &"" or action_down == &""
		):
			warnings.append("Input action simulation is enabled, but one or more 'Action' fields are empty.")
	
	if scale != Vector2.ONE:
		warnings.append("The node's native 'Scale' property should remain at (1, 1) to avoid layout issues.
		Please use the custom 'Joystick Scale' property under the 'Visual' group to resize the control.")
	return warnings


func _notification(what: int) -> void:
	if what == NOTIFICATION_TRANSFORM_CHANGED:
		if Engine.is_editor_hint():
			update_configuration_warnings()


func _ready() -> void:
	set_notify_transform(true)
	%Base.show_behind_parent = true
	%Stick.show_behind_parent = true
	if not Engine.is_editor_hint():
		_set_input_deadzones()
		await get_tree().process_frame
		_default_position = global_position
		if _is_dynamic_mode():
			%Base.modulate.a = 0.0
			%Stick.modulate.a = 0.0


func _process(_delta: float) -> void:
	if Engine.is_editor_hint() or editor_draw_in_game:
		queue_redraw()


func _draw() -> void:
	if not Engine.is_editor_hint() and not editor_draw_in_game:
		return
	
	var base_position: Vector2 = %Base.position + %Base.size / 2
	var base_radius: float = _get_base_radius()
	var base_alpha: float = %Base.modulate.a
	
	if editor_draw_dynamic_area:
		var area: Rect2 = _get_active_area_rect()
		var local_area: Rect2 = Rect2(area.position - global_position, area.size)
		draw_rect(local_area, Color(0.0, 1.0, 0.0, 1.0), false, 1.0)
		draw_rect(local_area, Color(0.0, 1.0, 0.0, 0.2))
	
	if editor_draw_boundary and %Base.texture:
		var touch_boundary_radius: float = base_radius * boundary
		var stroke_color: Color = Color(0.0, 0.6, 0.7, base_alpha)
		var fill_color: Color = Color(0.0, 0.6, 0.7, base_alpha * 0.4)
		draw_circle(base_position, touch_boundary_radius, stroke_color, false, 1.0)
		draw_circle(base_position, touch_boundary_radius, fill_color)
	
	if editor_draw_deadzone and deadzone > 0.0:
		var deadzone_radius: float = base_radius * deadzone
		var stroke_color: Color = Color(1.0, 0.1, 0.1, base_alpha)
		var fill_color: Color = Color(1.0, 0.1, 0.1, base_alpha * 0.2)
		draw_circle(base_position, deadzone_radius, stroke_color, false, 1.0)
		draw_circle(base_position, deadzone_radius, fill_color)


func _input(event: InputEvent) -> void:
	if Engine.is_editor_hint():
		return
	
	if event is InputEventScreenTouch:
		if event.pressed:
			var area: Rect2 = _get_active_area_rect()
			var is_inside_area: bool = area.has_point(event.position)
			
			if (
					(_is_dynamic_mode() and is_inside_area)
					or (not _is_dynamic_mode() and _is_touched_inside(event.position))
			):
				if _touch_index == -1:
					_touch_index = event.index
					
					if _is_dynamic_mode():
						_reset_joystick_position(event.position)
						_set_dynamic_visibility(0.5)
					
					pressed.emit()
					if direction_mode == DirectionUtils.Modes.DIRECTION_360:
						_vibrate(50)
					_update_stick(event.position)
		elif event.index == _touch_index:
			_touch_index = -1
			_input_direction = Vector2.ZERO
			_update_input_actions()
			_reset_stick()
			
			if _is_dynamic_mode():
				_set_dynamic_visibility(0.0)
			
			direction_changed.emit(Vector2.ZERO)
			released.emit()
	elif event is InputEventScreenDrag and event.index == _touch_index:
		_update_stick(event.position)


# Checks if a [param touch_position] is within the base's interactive radius.
func _is_touched_inside(touch_position: Vector2) -> bool:
	return touch_position.distance_to(_get_base_global_center()) <= _get_base_radius() * boundary


# Check if the [member Joystick.mode] is dynamic.
func _is_dynamic_mode() -> bool:
	return mode != Modes.STATIC


# Calculates the bounding box for the dynamic touch area based on margins.
func _get_active_area_rect() -> Rect2:
	var screen_size: Vector2 = (
			get_viewport().get_visible_rect().size if not Engine.is_editor_hint()
			else Vector2(
				ProjectSettings.get_setting("display/window/size/viewport_width"),
				ProjectSettings.get_setting("display/window/size/viewport_height"),
			)
	)
	var x: float = screen_size.x * dynamic_area_left_margin
	var y: float = screen_size.y * dynamic_area_top_margin
	var w: float = screen_size.x * (dynamic_area_right_margin - dynamic_area_left_margin)
	var h: float = screen_size.y * (dynamic_area_bottom_margin - dynamic_area_top_margin)
	return Rect2(x, y, w, h)


# Returns the local center position of the base.
func _get_base_center() -> Vector2:
	return (%Base.size * %Base.scale) / 2.0


# Returns the global center position of the base.
func _get_base_global_center() -> Vector2:
	return %Base.global_position + _get_base_center()


# Returns the radius of the base based on its size and scale.
func _get_base_radius() -> float:
	return (%Base.size.x / 2.0) * joystick_scale


# Returns the local center position of the stick.
func _get_stick_center() -> Vector2:
	return (%Stick.size * %Stick.scale) / 2.0


# Returns the global center position of the stick.
func _get_stick_global_center() -> Vector2:
	return %Stick.global_position + _get_stick_center()


# Smoothly fades the joystick visual components in or out.
func _set_dynamic_visibility(value: float) -> void:
	var tween: Tween = create_tween()
	tween.tween_property(%Base, "modulate:a", value, 0.2)
	tween.parallel().tween_property(%Stick, "modulate:a", value, 0.2)


# Define the deadzones for the actions [member Joystick.action_left],
# [member Joystick.action_up], [member Joystick.action_right],
# and [member Joystick.action_down] according to the [member Joystick.deadzone] defined in the joystick.
func _set_input_deadzones() -> void:
	for action: StringName in [action_left, action_up, action_right, action_down]:
		InputMap.action_set_deadzone(action, deadzone)


# Moves the entire joystick to a [param new_position] during dynamic activation
func _reset_joystick_position(new_position: Vector2) -> void:
	var screen_size: Vector2 = get_viewport().get_visible_rect().size
	global_position = new_position.clamp(
			_get_base_center(),
			screen_size - _get_base_center()
	)


# Resets the stick to the center of the base with an animation.
func _reset_stick() -> void:
	if _tween_stick and _tween_stick.is_running():
		_tween_stick.kill()
	_tween_stick = create_tween()
	_tween_stick.tween_property(
			%Stick, "global_position",
			_get_base_global_center() - _get_stick_center(), 0.2
	).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	
	if not _is_dynamic_mode():
		_tween_stick.parallel().tween_property(%Stick, "modulate:a", 1.0, 0.2)


# Synchronizes the joystick's direction with Godot's Input singleton actions.
func _update_input_actions() -> void:
	if Engine.is_editor_hint() or not action_enabled:
		return
	
	var actions: Dictionary[StringName, float] = {
		action_up: -_input_direction.y,
		action_down: _input_direction.y,
		action_left: -_input_direction.x,
		action_right: _input_direction.x,
	}
	
	for action: StringName in actions:
		var strength = max(0.0, actions[action])
		if strength > 0.0:
			Input.action_press(action, strength)
		else:
			Input.action_release(action)


# Calculates the stick's [param new_position] and emits direction changes.
func _update_stick(new_position: Vector2) -> void:
	if _tween_stick and _tween_stick.is_running():
		_tween_stick.kill()
	
	var center: Vector2 = _get_base_global_center()
	var offset: Vector2 = new_position - center
	var base_radius: float = _get_base_radius()
	var boundary_radius: float = base_radius * boundary
	
	# Following mode
	if mode == Modes.FOLLOWING and offset.length() > boundary_radius:
		var extra_distance: float = offset.length() - boundary_radius
		var move_vector = offset.normalized() * extra_distance
		global_position += move_vector
		center = _get_base_global_center()
		offset = new_position - center
	
	var visual_offset = offset
	if visual_offset.length() > base_radius:
		visual_offset = visual_offset.normalized() * base_radius
	
	%Stick.global_position = center + visual_offset - _get_stick_center()
	
	var raw_input: Vector2 = offset / base_radius
	var new_direction: Vector2 = DirectionUtils.snapped(
			raw_input,
			direction_mode,
			deadzone
	)
	
	if not _is_dynamic_mode():
		%Stick.modulate.a = 0.6 if new_direction == Vector2.ZERO else 1.0
	
	if _input_direction != new_direction:
		_input_direction = new_direction
		direction_changed.emit(_input_direction)
		if _input_direction and direction_mode != DirectionUtils.Modes.DIRECTION_360:
			_vibrate(20)
	_update_input_actions()


# Triggers device vibration if enabled and supported.
# The [param duration_ms] is multiplied by [member vibration_force].
func _vibrate(duration_ms: int = 30) -> void:
	if OS.has_feature("mobile") and vibration_enabled:
		Input.vibrate_handheld(duration_ms * vibration_force)
