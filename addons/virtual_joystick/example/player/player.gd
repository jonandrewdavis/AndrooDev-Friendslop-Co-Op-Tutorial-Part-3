extends CharacterBody2D


const SPEED: float = 90.0

var direction: Vector2

func _physics_process(_delta: float) -> void:
	direction = Input.get_vector(&"ui_left", &"ui_right", &"ui_up", &"ui_down")
	velocity = SPEED * direction
	move_and_slide()
	_animate()


func aim_weapon(target_direction: Vector2) -> void:
	$CurrentWeapon.look_at($CurrentWeapon.global_position + target_direction)
	%Weapon.scale.y = -1.0 if target_direction.x < 0.0 else 1.0
	%Weapon.shoot(target_direction)


func _animate() -> void:
	if direction.x > 0.0:
		$AnimatedSprite2D.flip_h = false
	elif direction.x < 0.0:
		$AnimatedSprite2D.flip_h = true
	$AnimatedSprite2D.play(&"walk" if direction else &"idle")
