extends Enemy

@export var speed: = Vector2(150.0, 1000.0)
@onready var player: Player = get_parent().get_parent().get_node("Player")
@onready var direction: = get_direction()
@onready var state_machine = $AnimationTree.get("parameters/playback")
@onready var timer: = Timer.new()

func _ready():
	status = "run"
	$AnimationTree.active = true

func _physics_process(delta: float) -> void:
	if $HealthComponent.get_health() <= 0:
		die()
		return
	velocity = calculate_move_velocity(
		velocity,
		direction,
		speed
	)
	check_sprite(velocity)
	super._physics_process(delta)



func check_sprite(_velocity: Vector2):
	if _velocity.x != 0.0:
		flipped = _velocity.x < 0.0
		
	if status == "run":
		state_machine.travel("running" if not flipped else "running flipped")
	
	if status == "attack" and timer != null:
		if timer.time_left > 0:
			return
		state_machine.travel("attack" if not flipped else "attack flipped")
		var attack: = Attack.new()
		attack.attack_damange = 2
		attack.attack_name = "zombie"
		attack.came_from_enemy = true
		player.move_and_slide()
		if await player.get_node("HealthComponent").damange(attack, true, 1.5):
			player.die()
		await get_tree().create_timer(1).timeout

func get_direction() -> Vector2:
	return Vector2(
		1.0,
		1.0
	)

func calculate_move_velocity(
	linear_velocity: Vector2,
	_direction: Vector2,
	_speed: Vector2,
	) -> Vector2:
	var new_velocity: = linear_velocity
	new_velocity.x = _speed.x * _direction.x
	new_velocity.y += gravity * get_physics_process_delta_time()
	if _direction.y == -1.0:
		new_velocity.y = _speed.y * direction.y
	elif impulse != Vector2.ZERO or is_on_wall() or (is_on_floor() and !$RayCast2D.is_colliding()):
		direction.x *= -1
		new_velocity.x *= -10
		$RayCast2D.position.x *= -1.0
		
	if status == "attack":
		new_velocity.x = 0
	
	return new_velocity
	
func die() -> void:
	if status != "die":
		$"Player hitbox/CollisionShape2D".disabled = true
		status = "die"
		state_machine.travel("die")

func add_coins_and_die() -> void:
	PlayerData.coins_in_level += coins_drop
	queue_free()

func _on_player_hitbox_entered(body):
	if body is Player:
		if timer.wait_time == 0:
			timer.wait_time = 0.2
			timer.one_shot = true
			add_child(timer)
			timer.start()
		status = "attack"

func _on_player_hitbox_exited(_body):
	status = "run"
