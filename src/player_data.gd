extends Node

signal coins_in_level_updated
signal throwables_number_update

var level: float = 2
var coins_in_level: = 0 : set = _set_coins_in_level
var coins: = 0

func _set_coins_in_level(_value: int) -> void:
	coins_in_level = _value
	emit_signal("coins_in_level_updated")

func reset_level() -> void:
	get_tree().reload_current_scene()
	coins_in_level = 0
