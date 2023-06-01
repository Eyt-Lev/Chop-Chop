extends CharacterBody2D
class_name Entity


var flipped = false
@export var status: = "idle"
@export var gravity: = 3000.0
var impulse = Vector2.ZERO
var invincible = false
@export var throwables: float: set = _set_throwables

func _ready():
	throwables = throwables

func _set_throwables(value):
	throwables = value
	if self is Player:
		PlayerData.emit_signal("throwables_number_update")

func _physics_process(_delta: float) -> void:
	if impulse != Vector2.ZERO:
		velocity = impulse
		impulse = Vector2.ZERO
	move_and_slide()
