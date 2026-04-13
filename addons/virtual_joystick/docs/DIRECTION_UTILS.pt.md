# 🛠️ Direction Utils

Biblioteca utilitária estática para manipulação de direções 2D e ajuste de vetores na Godot 4.x.

Ela facilita a conversão entre `Enum`, `Vector2` e `StringName`, além de processar entradas brutas para transformá-las em direções discretas (como 4 ou 8 direções).

## 🌎 Linguagem

- [English](./DIRECTION_UTILS.md)
- Português

## 📋 Sumário

- [🛠️ Direction Utils](#️-direction-utils)
  - [🌎 Linguagem](#-linguagem)
  - [📋 Sumário](#-sumário)
  - [🔢 Enumerações](#-enumerações)
    - [Modes](#modes)
    - [Directions](#directions)
  - [📄 Métodos](#-métodos)
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

## 🔢 Enumerações

### Modes
Define os modos de ajuste das direções:
- `DIRECTION_2_H`: Apenas direções horizontais (Esquerda, Direita).
- `DIRECTION_2_V`: Apenas direções verticais (Cima, Baixo).
- `DIRECTION_4`: 4 direções (Cima, Baixo, Esquerda, Direita).
- `DIRECTION_8`: 8 direções (Inclui as diagonais).
- `DIRECTION_360`: Sem alinhamento (analógico completo).

---

### Directions
Representação interna das direções suportadas:
- `UP`: Direção para cima (Norte).
- `RIGHT`: Direção para a direita (Leste).
- `DOWN`: Direção para baixo (Sul).
- `LEFT`: Direção para a esquerda (Oeste).
- `UP_RIGHT`: Direção diagonal superior direita (Nordeste).
- `UP_LEFT`: Direção diagonal superior esquerda (Noroeste).
- `DOWN_RIGHT`: Direção diagonal inferior direita (Sudeste).
- `DOWN_LEFT`: Direção diagonal inferior esquerda (Sudoeste).

## 📄 Métodos

### get_dir_enum_by_name
`Directions get_dir_enum_by_name(dir_name: StringName) static`

Retorna o `Directions` associado com o `dir_name` especifico.

---

### get_dir_enum_by_vector
`Directions get_dir_enum_by_vector(dir_vector: Vector2) static`

Retorna o `Directions` mais proximo do `dir_vector` especifico.

---

### get_dir_name_by_enum
`StringName get_dir_name_by_enum(dir_enum: Directions) static`

Retorna a `StringName` do `dir_enum` especifico.

---

### get_dir_name_by_vector
`StringName get_dir_name_by_vector(dir_vector: Vector2) static`

Retorna a `StringName` do `dir_vector` especifico.

---

### get_dir_vector_by_enum
`Vector2 get_dir_vector_by_enum(dir_enum: Directions) static`

Retorna o `Vector2` normalizado da `dir_enum` especifica.

---

### get_dir_vector_by_name
`Vector2 get_dir_vector_by_name(dir_name: StringName) static`

Retorna o `Vector2` associado com `dir_name` especifica.

---

### get_opposite_dir_enum
`Directions get_opposite_dir_enum(dir_enum: Directions) static`

Retorna o `Directions` oposto da `dir_enum` específica.
```gdscript
# Returns Directions.DOWN
get_opposite_dir_enum(Directions.UP)

# Returns Directions.DOWN_LEFT
get_opposite_dir_enum(Directions.UP_RIGHT)
```

---

### get_opposite_dir_name
`StringName get_opposite_dir_name(dir_name: StringName) static`

Retorna a `StringName` oposto da `dir_name` específica.
```gdscript
# Returns &"down"
get_opposite_dir_name(&"up")

# Returns &"down_left"
get_opposite_dir_name(&"up_right")
```

---

### get_opposite_dir_vector
`Vector2 get_opposite_dir_vector(dir_vector: Vector2) static`

Retorno o `Vector2` oposto do `dir_vector` especifico.
```gdscript
# Returns Vector2.DOWN
get_opposite_dir_vector(Vector2.UP)

# Returns Vector2(-1, 1)
get_opposite_dir_vector(Vector2(1, -1))
```

---

### snapped
`Vector2 snapped(raw_vector: Vector2, mode: Modes = 2, deadzone: float = 0.2) static`

Ajusta o `raw_vector` a uma direção discreta baseada no `mode` escolhido. Returna `Vector2.ZERO` caso o comprimento do vetor seja menor que a `deadzone`.