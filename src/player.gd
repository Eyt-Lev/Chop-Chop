extends Entity
class_name Player


@onready var state_machine = $AnimationTree.get("parameters/playback")
var jump_count: = 0
@export var speed: = Vector2(300.0, 1000.0)
var on_ladder: = false
@onready var weapon: Weapon = $Weapon

func _physics_process(delta: float) -> void:
	var direction: = get_direction()
	velocity = calculate_move_velocity(
		velocity,
		direction,
		speed
	)
	check_status()
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
	super._physics_process(delta)
	
func check_status():
	if Input.is_action_just_pressed("attack"):
		status = "attack"
	elif Input.is_action_just_pressed("throw"):
		status = "throw"
	elif on_ladder:
		if is_on_floor():
			status = "back"
		else:
			status = "climb"
	elif velocity.y > 250.0 and not is_on_floor():
		status = "fall"
	elif velocity.y < 0.0:
		status = "jump"
	elif velocity.x != 0.0 and is_on_floor():
		status = "running"
	elif is_on_floor():
		status = "idle"
	
	if velocity.x != 0.0:
		flipped = velocity.x < 0.0
	status += " flipped" if flipped and not status.contains("flipped") else ""
	$CPUParticles2D.emitting = status != "idle"
	
	state_machine.travel(status)

func get_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		check_jump()
	)

func check_jump() -> float:
	var can_jump: = jump_count < 2
	if is_on_floor():
		jump_count = 0
	
	var jumped: = Input.is_action_just_pressed("up")
	if jumped:
		jump_count += 1
	if status.contains("climb"):
		if Input.get_action_strength("down"):
			return 1.0
		velocity.y = -50
		check_status()
		return -1.0 if Input.get_action_strength("up") else 0.0
	else:
		return -1.0 if jumped and can_jump else 1.0

func calculate_move_velocity(
	linear_velocity: Vector2,
	direction: Vector2,
	_speed: Vector2,
	) -> Vector2:
	var new_velocity: = linear_velocity
	new_velocity.x = _speed.x * direction.x
	new_velocity.y += gravity * get_physics_process_delta_time()
	if direction.y == -1.0:
		new_velocity.y = _speed.y * direction.y
	return new_velocity

func die() -> void:
	PlayerData.reset_level()

func _on_hit_box_body_entered(body):
	if body is Enemy:
		var attack: = Attack.new()
		attack.attack_damange = weapon.weapon_damange
		attack.attack_name = weapon.weapon_name
		attack.came_from_enemy = true
		if await body.get_node("HealthComponent").damange(attack, true, 0):
			body.die()

func throw():
	if throwables <= 0:
		return
	var arrow = load("res://scenes/arrow.tscn").instantiate()
	get_parent().add_child(arrow)
	arrow.flipped = flipped
	arrow.global_position = $Marker2D.global_position
	throwables -= 1
	
