extends Node2D
class_name HealthComponent

signal health_updated

@export var _health_bar: Range
@export var _hearts_bar: HBoxContainer
@export var _max_health: float
@onready var _health: = _max_health

func _ready():
	update_health_bar(_health)
	if _health_bar != null:
		_health_bar.max_value = _max_health * 10 

func damange(_attack: Attack, _check_if_reached_0: bool=true, _invincible_time: float=0, consider_invicible=true) -> bool:
	if get_parent().invincible and consider_invicible:
		return false
	
	_health -= _attack.attack_damange
	
	update_health_bar(_health)
	
	if get_parent().has_node("HitParticles"):
		get_parent().get_node("HitParticles").emitting = true
	
	if _check_if_reached_0 and _health <= 0:
		return true
	
	if _invincible_time > 0.0:
		get_parent().invincible = true
		await get_tree().create_timer(_invincible_time).timeout
		get_parent().invincible = false

	return false

func get_health() -> float:
	return _health

func add_health(_points: float, _overflow: bool=false) -> void:
	if _overflow:
		_health += _points
	else:
		_health = min(_max_health, _health + _points)

func update_health_bar(_value: float) -> void:
	if _health_bar != null:
		_health_bar.value  = _value * 10
	else:
		_hearts_bar.update_partial(_value)



