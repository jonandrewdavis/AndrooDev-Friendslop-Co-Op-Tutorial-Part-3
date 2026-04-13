extends Control

@onready var knob = $Knob
@onready var base = $Base

# 👇 Dynamic dropdown from Input Map
func _get_actions() -> PackedStringArray:
	return InputMap.get_actions()

@export var action_left: String = ""
@export var action_right: String = ""
@export var action_up: String = ""
@export var action_down: String = ""

@export var deadzone := 0.1

var radius := 100.0
var touch_id := -1
var output := Vector2.ZERO

func _ready():
	radius = base.size.x * 0.5
	_reset_knob()

func _gui_input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			if touch_id == -1:
				touch_id = event.index
				_update_knob(event.position)
		else:
			if event.index == touch_id:
				touch_id = -1
				_release_actions()
				output = Vector2.ZERO
				_reset_knob()

	elif event is InputEventScreenDrag:
		if event.index == touch_id:
			_update_knob(event.position)

func _update_knob(pos: Vector2):
	var center = size * 0.5
	var offset = pos - center

	if offset.length() > radius:
		offset = offset.normalized() * radius

	knob.position = center + offset - knob.size * 0.5

	output = offset / radius

	if output.length() < deadzone:
		output = Vector2.ZERO

	_apply_actions()

func _apply_actions():
	_release_actions()

	if output == Vector2.ZERO:
		return

	if output.x < 0:
		Input.action_press(action_left, abs(output.x))
	elif output.x > 0:
		Input.action_press(action_right, abs(output.x))

	if output.y < 0:
		Input.action_press(action_up, abs(output.y))
	elif output.y > 0:
		Input.action_press(action_down, abs(output.y))

func _release_actions():
	Input.action_release(action_left)
	Input.action_release(action_right)
	Input.action_release(action_up)
	Input.action_release(action_down)

func _reset_knob():
	var center = size * 0.5
	knob.position = center - knob.size * 0.5
	
func _get_property_list():
	var actions = InputMap.get_actions()
	var hint_string = ",".join(actions)

	return [
		{
			"name": "action_left",
			"type": TYPE_STRING,
			"hint": PROPERTY_HINT_ENUM,
			"hint_string": hint_string,
			"usage": PROPERTY_USAGE_DEFAULT
		},
		{
			"name": "action_right",
			"type": TYPE_STRING,
			"hint": PROPERTY_HINT_ENUM,
			"hint_string": hint_string,
			"usage": PROPERTY_USAGE_DEFAULT
		},
		{
			"name": "action_up",
			"type": TYPE_STRING,
			"hint": PROPERTY_HINT_ENUM,
			"hint_string": hint_string,
			"usage": PROPERTY_USAGE_DEFAULT
		},
		{
			"name": "action_down",
			"type": TYPE_STRING,
			"hint": PROPERTY_HINT_ENUM,
			"hint_string": hint_string,
			"usage": PROPERTY_USAGE_DEFAULT
		}
	]
