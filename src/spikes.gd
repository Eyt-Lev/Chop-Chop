extends Area2D


func _on_body_entered(body):
	if body is Entity:
		var attack: = Attack.new()
		attack.attack_damange = 1
		attack.attack_name = "spikes"
		attack.came_from_enemy = false
		body.impulse.y = -1200
		if await body.get_node("HealthComponent").damange(attack, true, 1.5):
			body.die()
