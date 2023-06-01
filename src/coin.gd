@tool
extends Area2D

@export_enum("Bronze", "Silver", "Gold") var type: int : set = set_texture
var values = {
	0: 5,
	1: 12,
	2: 30
	}
var sprites: = {
	5: "res://assets/coinBronze.png",
	12: "res://assets/coinSilver.png",
	30: "res://assets/coinGold.png",
}
@onready var value = values[type]

func set_texture(_value):
	type = _value
	value = values[type]
	$Sprite.texture = load(sprites[value])


func _on_body_entered(body):
	if body is Player:
		$AnimationPlayer.play("fade_out")

func _kill():
	PlayerData.coins_in_level += int(value)
	queue_free()
