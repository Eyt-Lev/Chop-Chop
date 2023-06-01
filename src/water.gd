extends Area2D


func _on_body_entered(body):
	if body is Entity:
		var attack: = Attack.new()
		attack.attack_damange = body.get_node("HealthComponent").get_health()
		attack.attack_name = "water"
		attack.came_from_enemy = false
		if body.get_node("HealthComponent").damange(attack, true, 0, false):
			body.die()
