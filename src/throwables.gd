extends Node

class_name Throwable

@export var weapon_sprite: Sprite2D
@export var weapon_damange: float
@export var weapon_name: String

func throw() -> void:
	var weapon = Sprite2D.new()
	weapon.texture = weapon_sprite
	weapon.global_position = get_parent().global_position
	get_parent().get_parent().add_child(weapon)
	print(weapon)
