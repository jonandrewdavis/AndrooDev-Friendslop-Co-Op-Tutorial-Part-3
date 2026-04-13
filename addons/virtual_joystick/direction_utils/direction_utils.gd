class_name DirectionUtils
extends Node
## A static utility library for manipulating 2D directions
## and vector snapping in Godot 4.x.
##
## It facilitates conversion between [Enum], [Vector2], and [StringName],
## as well as processing raw inputs to transform them into discrete directions
## (such as 4-way or 8-way).

## Defines the direction snapping modes:
enum Modes {
	DIRECTION_2_H, ## Horizontal directions only (Left, Right).
	DIRECTION_2_V, ## Vertical directions only (Up, Down).
	DIRECTION_4, ## 4-Way (Up, Down, Left, Right).
	DIRECTION_8, ## 8-Way (Includes diagonals).
	DIRECTION_360, ## No snapping (Full analog).
}

## Internal representation of supported directions:
enum Directions {
	UP, ## Upward direction (North).
	RIGHT, ## Rightward direction (East).
	DOWN, ## Downward direction (South).
	LEFT, ## Leftward direction (West).
	UP_RIGHT, ## Upper-right diagonal (Northeast).
	UP_LEFT, ## Upper-left diagonal (Northwest).
	DOWN_RIGHT, ## Lower-right diagonal (Southeast).
	DOWN_LEFT, ## Lower-left diagonal (Southwest).
}

# Holds direction data including names and normalized vectors.
static var _data: Dictionary[Directions, Dictionary] = {
	Directions.UP: {"name": &"up", "vector": Vector2.UP},
	Directions.RIGHT: {"name": &"right", "vector": Vector2.RIGHT},
	Directions.DOWN: {"name": &"down", "vector": Vector2.DOWN},
	Directions.LEFT: {"name": &"left", "vector": Vector2.LEFT},
	Directions.UP_RIGHT: {"name": &"up_right", "vector": Vector2(1.0, -1.0).normalized()},
	Directions.UP_LEFT: {"name": &"up_left", "vector": Vector2(-1.0, -1.0).normalized()},
	Directions.DOWN_RIGHT: {"name": &"down_right", "vector": Vector2(1.0, 1.0).normalized()},
	Directions.DOWN_LEFT: {"name": &"down_left", "vector": Vector2(-1.0, 1.0).normalized()},
}

# Internal map for quick reference to the names of the numbered directions.
static var _names_to_enum: Dictionary[StringName, Directions] = {}

static func _static_init() -> void:
	for dir_enum: Directions in _data:
		var dir_name: StringName = _data[dir_enum]["name"]
		_names_to_enum[dir_name] = dir_enum


## Returns the [enum Directions] enum associated with a specific [param dir_name].
static func get_dir_enum_by_name(dir_name: StringName) -> Directions:
	if not _names_to_enum.has(dir_name):
		push_error("Direction name not found: ", dir_name)
	return _names_to_enum.get(dir_name, Directions.UP)


## Returns the closest [enum Directions] enum for a specific [param dir_vector].
static func get_dir_enum_by_vector(dir_vector: Vector2) -> Directions:
	var dir_norm: Vector2 = dir_vector.normalized()
	var best_dir: Directions = Directions.UP
	var max_dot: float = -1.0
	
	for dir_enum: Directions in _data:
		var dot: float = _data[dir_enum]["vector"].dot(dir_norm)
		if dot > max_dot:
			max_dot = dot
			best_dir = dir_enum
	return best_dir


## Returns the [StringName] of a specific [param dir_enum].
static func get_dir_name_by_enum(dir_enum: Directions) -> StringName:
	return _data[dir_enum]["name"]


## Returns the [StringName] of a specific [param dir_vector].
static func get_dir_name_by_vector(dir_vector: Vector2) -> StringName:
	return get_dir_name_by_enum(get_dir_enum_by_vector(dir_vector))


## Returns the normalized [Vector2] of a specific [param dir_enum].
static func get_dir_vector_by_enum(dir_enum: Directions) -> Vector2:
	return _data[dir_enum]["vector"]


## Returns the [Vector2] associated with a specific [param dir_name].
static func get_dir_vector_by_name(dir_name: StringName) -> Vector2:
	return get_dir_vector_by_enum(get_dir_enum_by_name(dir_name))


## Returns the opposite [enum Directions] enum of a specific [param dir_enum].
## [codeblock lang=gdscript]
## # Returns Directions.DOWN
## get_opposite_dir_enum(Directions.UP)
##
## # Returns Directions.DOWN_LEFT
## get_opposite_dir_enum(Directions.UP_RIGHT)
## [/codeblock]
static func get_opposite_dir_enum(dir_enum: Directions) -> Directions:
	return get_dir_enum_by_vector(_data[dir_enum]["vector"] * -1.0)


## Returns the opposite [StringName] of a specific [param dir_name].
## [codeblock lang=gdscript]
## # Returns &"down"
## get_opposite_dir_name(&"up")
##
## # Returns &"down_left"
## get_opposite_dir_name(&"up_right")
## [/codeblock]
static func get_opposite_dir_name(dir_name: StringName) -> StringName:
	var dir_enum = get_dir_enum_by_name(dir_name)
	return get_dir_name_by_enum(get_opposite_dir_enum(dir_enum))


## Returns the opposite [Vector2] of a specific [param dir_vector].
## [codeblock lang=gdscript]
## # Returns Vector2.DOWN
## get_opposite_dir_vector(Vector2.UP)
##
## # Returns Vector2(-1, 1)
## get_opposite_dir_vector(Vector2(1, -1))
## [/codeblock]
static func get_opposite_dir_vector(dir_vector: Vector2) -> Vector2:
	return dir_vector * -1


## Snaps the [param raw_vector] to a discrete direction based on the chosen [param mode].
## Returns [constant Vector2.ZERO] if the vector length is smaller than the [param deadzone].
static func snapped(
		raw_vector: Vector2,
		mode: Modes = Modes.DIRECTION_4,
		deadzone: float = 0.2
) -> Vector2:
	if raw_vector.length_squared() < pow(deadzone, 2.0):
		return Vector2.ZERO
	
	if mode == Modes.DIRECTION_360:
		return raw_vector
	
	var dir_norm: Vector2 = raw_vector.normalized()
	var best_vector: Vector2 = Vector2.ZERO
	var max_dot: float = -1.0
	
	for dir_enum: Directions in _get_test_list(mode):
		var test_vector: Vector2 = get_dir_vector_by_enum(dir_enum)
		var dot: float = test_vector.dot(dir_norm)
		if dot > max_dot:
			max_dot = dot
			best_vector = test_vector
	return best_vector


# Internal helper to get a list of directions to test based on [param mode].
static func _get_test_list(mode: Modes) -> Array[Directions]:
	match mode:
		Modes.DIRECTION_2_H: return [Directions.LEFT, Directions.RIGHT]
		Modes.DIRECTION_2_V: return [Directions.UP, Directions.DOWN]
		Modes.DIRECTION_4: return [
			Directions.UP,
			Directions.RIGHT,
			Directions.DOWN,
			Directions.LEFT
		]
		_: return _data.keys()
