# 🛠️ Direction Utils

A static utility library for manipulating 2D directions and vector snapping in Godot 4.x.

It facilitates conversion between `Enum`, `Vector2`, and `StringName`, as well as processing raw inputs to transform them into discrete directions (such as 4-way or 8-way).

## 🌎 Language

- English
- [Português](./DIRECTION_UTILS.pt.md)

## 📋 Table of Contents

- [🛠️ Direction Utils](#️-direction-utils)
  - [🌎 Language](#-language)
  - [📋 Table of Contents](#-table-of-contents)
  - [🔢 Enumerations](#-enumerations)
    - [Modes](#modes)
    - [Directions](#directions)
  - [📄 Methods](#-methods)
    - [get\_dir\_enum\_by\_name](#get_dir_enum_by_name)
    - [get\_dir\_enum\_by\_vector](#get_dir_enum_by_vector)
    - [get\_dir\_name\_by\_enum](#get_dir_name_by_enum)
    - [get\_dir\_name\_by\_vector](#get_dir_name_by_vector)
    - [get\_dir\_vector\_by\_enum](#get_dir_vector_by_enum)
    - [get\_dir\_vector\_by\_name](#get_dir_vector_by_name)
    - [get\_opposite\_dir\_enum](#get_opposite_dir_enum)
    - [get\_opposite\_dir\_name](#get_opposite_dir_name)
    - [get\_opposite\_dir\_vector](#get_opposite_dir_vector)
    - [snapped](#snapped)

## 🔢 Enumerations

### Modes
Defines the direction snapping modes:
- `DIRECTION_2_H`: Horizontal directions only (Left, Right).
- `DIRECTION_2_V`: Vertical directions only (Up, Down).
- `DIRECTION_4`: 4-Way (Up, Down, Left, Right).
- `DIRECTION_8`: 8-Way (Includes diagonals).
- `DIRECTION_360`: No snapping (Full analog).

---

### Directions
Internal representation of supported directions:
- `UP`: Upward direction (North).
- `RIGHT`: Rightward direction (East).
- `DOWN`: Downward direction (South).
- `LEFT`: Leftward direction (West).
- `UP_RIGHT`: Upper-right diagonal (Northeast).
- `UP_LEFT`: Upper-left diagonal (Northwest).
- `DOWN_RIGHT`: Lower-right diagonal (Southeast).
- `DOWN_LEFT`: Lower-left diagonal (Southwest).

## 📄 Methods

### get_dir_enum_by_name
`Directions get_dir_enum_by_name(dir_name: StringName) static`

Returns the `Directions` enum associated with a specific `dir_name`.

---

### get_dir_enum_by_vector
`Directions get_dir_enum_by_vector(dir_vector: Vector2) static`

Returns the closest `Directions` enum for a specific `dir_vector`.

---

### get_dir_name_by_enum
`StringName get_dir_name_by_enum(dir_enum: Directions) static`

Returns the `StringName` of a specific `dir_enum`.

---

### get_dir_name_by_vector
`StringName get_dir_name_by_vector(dir_vector: Vector2) static`

Returns the `StringName` of a specific `dir_vector`.

---

### get_dir_vector_by_enum
`Vector2 get_dir_vector_by_enum(dir_enum: Directions) static`

Returns the normalized `Vector2` of a specific `dir_enum`.

---

### get_dir_vector_by_name
`Vector2 get_dir_vector_by_name(dir_name: StringName) static`

Returns the `Vector2` associated with a specific `dir_name`.

---

### get_opposite_dir_enum
`Directions get_opposite_dir_enum(dir_enum: Directions) static`

Returns the opposite `Directions` enum of a specific `dir_enum`.
```gdscript
# Returns Directions.DOWN
get_opposite_dir_enum(Directions.UP)

# Returns Directions.DOWN_LEFT
get_opposite_dir_enum(Directions.UP_RIGHT)
```

---

### get_opposite_dir_name
`StringName get_opposite_dir_name(dir_name: StringName) static`

Returns the opposite `StringName` of a specific `dir_name`.
```gdscript
# Returns &"down"
get_opposite_dir_name(&"up")

# Returns &"down_left"
get_opposite_dir_name(&"up_right")
```

---

### get_opposite_dir_vector
`Vector2 get_opposite_dir_vector(dir_vector: Vector2) static`

Returns the opposite `Vector2` of a specific `dir_vector`.
```gdscript
# Returns Vector2.DOWN
get_opposite_dir_vector(Vector2.UP)

# Returns Vector2(-1, 1)
get_opposite_dir_vector(Vector2(1, -1))
```

---

### snapped
`Vector2 snapped(raw_vector: Vector2, mode: Modes = 2, deadzone: float = 0.2) static`

Snaps the `raw_vector` to a discrete direction based on the chosen `mode`. Returns `Vector2.ZERO` if the vector length is smaller than the `deadzone`.