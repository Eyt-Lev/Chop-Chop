extends CharacterBody2D

var arrow_damange: = 2
var arrow_name: = "Arrow"
var from_enemy: = false
var flipped = false

@onready var collision: KinematicCollision2D

func _physics_process(delta):
	if flipped: $Sprite2D.rotation_degrees = 230
	velocity.x += delta * 300 if not flipped else -(delta*300)
	collision = move_and_collide(velocity)
	if collision != null and collision.get_collider_shape() == null:
		queue_free()


func _on_area_2d_body_entered(body):
	if body is Entity:
		var attack: = Attack.new()
		attack.attack_damange = arrow_damange
		attack.attack_name = arrow_name
		attack.came_from_enemy = from_enemy
		if await body.get_node("HealthComponent").damange(attack, true, 0):
			body.die()
		queue_free()


