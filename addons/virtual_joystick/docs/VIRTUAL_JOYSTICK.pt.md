# 🕹️ Virtual Joystick

Um Joystick Virtual personalizável para jogos mobile.

Gerencia a interface visual do controle, processa o toque do usuário e converte esse movimento em vetores de direção úteis para o seu jogo.

## 🌎 Linguagem

- [English](./JOYSTICK.md)
- Português

## 📋 Sumário

- [🕹️ Virtual Joystick](#️-virtual-joystick)
	- [🌎 Linguagem](#-linguagem)
	- [📋 Sumário](#-sumário)
	- [📡 Sinais](#-sinais)
		- [direction\_changed](#direction_changed)
		- [pressed](#pressed)
		- [released](#released)
	- [🔢 Enumerações](#-enumerações)
		- [Modes](#modes)
	- [⚙️ Propriedades](#️-propriedades)
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

## 📡 Sinais

### direction_changed
`direction_changed(input_direction: Vector2)`

Emitido quando a direção de entrada é alterado.

---

### pressed
`pressed()`

Emitido quando o joystick virtual é começa a ser pressionado.

---

### released
`released()`

Emitido quando o joystick virtual deixa de estar pressionado.

## 🔢 Enumerações

### Modes
`enum Modes:`

Define o comportamento do joystick virtual em relação à sua posição.
- `STATIC`: Mantém a posição fixa.
- `DYNAMIC`: Aparece na posição do toque e permanece ali.
- `FOLLOWING`: Aparece na posição do toque e acompanha o dedo caso esse se mova além do limite.

## ⚙️ Propriedades

### action_down
`StringName action_down [default: &"ui_down"] [property: setter]`

O nome da ação associada ao movimento para baixo.

---

### action_enabled
`bool action_enabled [default: true] [property: setter]`

Se `true`, simula ações de entrada automaticamente. Isso permite que você use `Input.get_vector()` em scripts, como o script do jogador.

---

### action_left
`StringName action_left [default: &"ui_left"] [property: setter]`

O nome da ação associada ao movimento para esquerda.

---

### action_right
`StringName action_right [default: &"ui_right"] [property: setter]`

O nome da ação associada ao movimento para direita.

---

### action_up
`StringName action_up [default: &"ui_up"] [property: setter]`

O nome da ação associada ao movimento para cima.

---

### base_texture
`Texture2D base_texture [default: <Object>] [property: setter]`

A textura usada para base do joystick virtual.

---

### boundary
`float boundary [default: 1.2]`

Define o limite da área que detectar do toque.

---

### deadzone
`float deadzone [default: 0.2] [property: setter]`

Define o limite mínimo de movimento necessário para registar uma direção.

---

### direction_mode
`DirectionUtils.Modes direction_mode [default: 4]`

Define o modo de ajuste das direções (Ex: 2 direções, 4 direções, 8 direções ou 360° Analógico).

---

### disabled
`bool disabled [default: false] [property: setter]`

Se `true`, o joystick virtual fica desativado e não pode processar entradas.

---

### dynamic_area_bottom_margin
`float dynamic_area_bottom_margin [default: 1.0] [property: setter]`

Deslocamento da área de ativação do joystick virtual no modo `DYNAMIC` ou `FOLLOWING`, a partir da borda inferior da tela (0,0 a 1,0).

---

### dynamic_area_left_margin
`float dynamic_area_left_margin [default: 0.0] [property: setter]`

Deslocamento da área de ativação do joystick virtual no modo `DYNAMIC` ou `FOLLOWING`, a partir da borda esquerda da tela (0,0 a 1,0).

---

### dynamic_area_right_margin
`float dynamic_area_right_margin [default: 1.0] [property: setter]`

Deslocamento da área de ativação do joystick virtual no modo `DYNAMIC` ou `FOLLOWING`, a partir da borda direita da tela (0,0 a 1,0).

---

### dynamic_area_top_margin
`float dynamic_area_top_margin [default: 0.0] [property: setter]`

Deslocamento da área de ativação do joystick virtual no modo `DYNAMIC` ou `FOLLOWING`, a partir da borda superior da tela (0,0 a 1,0).

---

### editor_draw_boundary
`bool editor_draw_touch_boundary [default: true] [property: setter]`

Desenha o limite máximo de toque para o joystick virtual no editor.

---

### editor_draw_deadzone
`bool editor_draw_deadzone [default: true] [property: setter]`

Desenha a área da zona morta no editor.

---

### editor_draw_dynamic_area
`bool editor_draw_dynamic_area [default: true] [property: setter]`

Desenha a área de ativação do modo `DYNAMIC` ou `FOLLOWING` no editor.

---

### editor_draw_in_game
`bool editor_draw_in_game [default: false]`

Desenha os indicadores visuais de depuração durante o jogo.

---

### joystick_scale
`float joystick_scale [default: 1.0] [property: setter]`

Escala global dos componentes UI do joystick virtual.

---

### mode
`Modes mode [default: 0] [property: setter]`

Define o modo do joystick virtual.

---

### stick_texture
`Texture2D stick_texture [default: <Object>] [property: setter]`

A textura utilizada para a alavanca do joystick virtual.

---

### vibration_enabled
`bool vibration_enabled [default: false]`

Se `true`, haverá feedback tátil com uma vibração quando as direções mudarem.
> **⚠️ Nota:**
> - Essa funcionalidade é exclusiva para **dispositivos móveis** (Android / iOS).
> 
> - No **Android**, você precisa habilitar a permissão **VIBRAR** nas configurações de exportação (`Project -> Export -> Android -> Permissions -> Vibrate`).
> 
> - No **iOS**, a permissão manual não é necessária, mas o feedback depende do usuário não estar no *"Modo de Pouca Energia"* e ter a vibração ativada nas configurações do sistema.

---

### vibration_force
`float vibration_force [default: 1.0]`

Define a força da vibração.
