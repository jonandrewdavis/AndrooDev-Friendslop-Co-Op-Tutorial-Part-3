extends Node2D


const _PreProjectile: PackedScene = preload("res://addons/virtual_joystick/example/weapon/projectile/projectile.tscn")
const TIME_TO_SHOOT: float = 0.135

var _can_shoot: bool = true

func shoot(target_direction: Vector2) -> void:
	if _can_shoot:
		_can_shoot = false
		%Weapon._spawn_projectile(target_direction)
		$ShootTimer.start(TIME_TO_SHOOT)


func _spawn_projectile(target_direction: Vector2) -> void:
	var new_projectile = _PreProjectile.instantiate()
	new_projectile.global_position = %ProjectileSpawnPosition.global_position
	new_projectile.direction = target_direction
	get_tree().root.add_child(new_projectile)


func _on_shoot_timer_timeout() -> void:
	_can_shoot = true
