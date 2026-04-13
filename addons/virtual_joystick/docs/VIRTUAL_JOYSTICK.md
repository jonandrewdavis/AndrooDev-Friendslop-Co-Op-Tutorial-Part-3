# 🕹️ Virtual Joystick

A customizable Virtual Joystick for mobile games.

It manages the control's visual interface, processes user touch input, and converts that movement into useful direction vectors for your game.

## 🌎 Language

- English
- [Português](./JOYSTICK.pt.md)

## 📋 Table of Contents

- [🕹️ Virtual Joystick](#️-virtual-joystick)
  - [🌎 Language](#-language)
  - [📋 Table of Contents](#-table-of-contents)
  - [📡 Signal](#-signal)
    - [direction\_changed](#direction_changed)
    - [pressed](#pressed)
    - [released](#released)
  - [🔢 Enumerations](#-enumerations)
    - [Modes](#modes)
  - [⚙️ Properties](#️-properties)
    - [action\_down](#action_down)
    - [action\_enabled](#action_enabled)
    - [action\_left](#action_left)
    - [action\_right](#action_right)
    - [action\_up](#action_up)
    - [base\_texture](#base_texture)
    - [boundary](#boundary)
    - [deadzone](#deadzone)
    - [direction\_mode](#direction_mode)
    - [disabled](#disabled)
    - [dynamic\_area\_bottom\_margin](#dynamic_area_bottom_margin)
    - [dynamic\_area\_left\_margin](#dynamic_area_left_margin)
    - [dynamic\_area\_right\_margin](#dynamic_area_right_margin)
    - [dynamic\_area\_top\_margin](#dynamic_area_top_margin)
    - [editor\_draw\_boundary](#editor_draw_boundary)
    - [editor\_draw\_deadzone](#editor_draw_deadzone)
    - [editor\_draw\_dynamic\_area](#editor_draw_dynamic_area)
    - [editor\_draw\_in\_game](#editor_draw_in_game)
    - [joystick\_scale](#joystick_scale)
    - [mode](#mode)
    - [stick\_texture](#stick_texture)
    - [vibration\_enabled](#vibration_enabled)
    - [vibration\_force](#vibration_force)


## 📡 Signal

### direction_changed
`direction_changed(input_direction: Vector2)`

Emitted when the input direction changes.

---

### pressed
`pressed()`

Emitted when the virtual joystick starts being pressed.

---

### released
`released()`

Emitted when the virtual joystick is released.

## 🔢 Enumerations

### Modes
`enum Modes:`

Defines the joystick's behavior regarding its position.
- `STATIC`: Keeps a fixed position.
- `DYNAMIC`: Appears at the touch position and stays there.
- `FOLLOWING`: Appears at the touch position and follows the finger if it moves beyond the boundary.

## ⚙️ Properties

### action_down
`StringName action_down [default: &"ui_down"] [property: setter]`

The name of the action associated with downward movement.

---

### action_enabled
`bool action_enabled [default: true] [property: setter]`

If `true`, automatically simulates input actions. This allows you to use `Input.get_vector()` in scripts, such as the player script.

---

### action_left
`StringName action_left [default: &"ui_left"] [property: setter]`

The name of the action associated with leftward movement.

---

### action_right
`StringName action_right [default: &"ui_right"] [property: setter]`

The name of the action associated with rightward movement.

---

### action_up
`StringName action_up [default: &"ui_up"]`

The name of the action associated with upward movement.

---

### base_texture
`Texture2D base_texture [default: <Object>] [property: setter]`

The texture used for the virtual joystick base.

---

### boundary
`float boundary [default: 1.2]`

Defines the limit of the area that detects touch.

---

### deadzone
`float deadzone [default: 0.2] [property: setter]`

Defines the minimum movement threshold required to register a direction.

---

### direction_mode
`DirectionUtils.Modes direction_mode [default: 4]`

Defines the direction snapping mode (e.g., 2-way, 4-way, 8-way, or 360° Analog).

---

### disabled
`bool disabled [default: false] [property: setter]`

If `true`, the virtual joystick is disabled and cannot process inputs.

---

### dynamic_area_bottom_margin
`float dynamic_area_bottom_margin [default: 1.0] [property: setter]`

Offset for the virtual joystick activation area in mode `DYNAMIC` or `FOLLOWING`, from the bottom edge of the screen (0.0 to 1.0).

---

### dynamic_area_left_margin
`float dynamic_area_left_margin [default: 0.0] [property: setter]`

Offset for the virtual joystick activation area in mode `DYNAMIC` or `FOLLOWING`, from the left edge of the screen (0.0 to 1.0).

---

### dynamic_area_right_margin
`float dynamic_area_right_margin [default: 1.0] [property: setter]`

Offset for the virtual joystick activation area in mode `DYNAMIC` or `FOLLOWING`, from the right edge of the screen (0.0 to 1.0).

---

### dynamic_area_top_margin
`float dynamic_area_top_margin [default: 0.0] [property: setter]`

Offset for the virtual joystick activation area in mode `DYNAMIC` or `FOLLOWING`, from the top edge of the screen (0.0 to 1.0).

---

### editor_draw_boundary
`bool editor_draw_touch_boundary [default: true] [property: setter]`

Draws the maximum touch boundary for the virtual joystick in the editor.

---

### editor_draw_deadzone
`bool editor_draw_deadzone [default: true] [property: setter]`

Draws the deadzone area in the editor.

---

### editor_draw_dynamic_area
`bool editor_draw_dynamic_area [default: true] [property: setter]`

Draws the activation area for mode `DYNAMIC` or `FOLLOWING` in the editor.

---

### editor_draw_in_game
`bool editor_draw_in_game [default: false]`

Displays debug visual indicators during gameplay.

---

### joystick_scale
`float joystick_scale [default: 1.0] [property: setter]`

Global scale of the virtual joystick UI components.

---

### mode
`Modes mode [default: 0] [property: setter]`

Defines the virtual joystick mode.

---

### stick_texture
`Texture2D stick_texture [default: <Object>] [property: setter]`

The texture used for the virtual joystick stick.

---

### vibration_enabled
`bool vibration_enabled [default: false]`

If `true`, there will be tactile feedback with a vibration when directions change.
> **⚠️ Note:**
> - This feature is exclusive to **mobile devices** (Android / iOS).
> 
> - On **Android**, you must enable the **VIBRATE** permission in the export settings (`Project -> Export -> Android -> Permissions -> Vibrate`).
> 
> - On **iOS**, manual permission is not required, but feedback depends on the user not being in *"Low Power Mode"* and having vibrations enabled in system settings.

---

### vibration_force
`float vibration_force [default: 1.0]`

Defines the vibration intensity.
