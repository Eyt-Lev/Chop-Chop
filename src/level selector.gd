extends Node2D

@onready var map:= 1
@onready var funcs:= [
	on_button_1_press,
	on_button_2_press,
	on_button_3_press,
	on_button_4_press,
	on_button_5_press,
]
func _ready():
	update()

func update():
	if not has_node("Map"):
		var mapScene = load("res://scenes/maps/map {i}.tscn".format({"i": str(map)})).instantiate()
		add_child(mapScene)
	$UI/Left.visible = map > 1
	$UI/Right.visible = map < 2
	for i in $Map/Control.get_child_count():
		var btn = $Map/Control.get_child(i) as TextureButton
		btn.connect("pressed", funcs[i])
		btn.disabled = i + 1 > PlayerData.level
	#get_tree().change_scene_to_file("res://scenes/levels/level 1.tscn")	


func on_button_1_press() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/level {level}.tscn".format({"level": str(1 + ((map - 1) * 5))}))
func on_button_2_press() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/level {level}.tscn".format({"level": str(2 + ((map - 1) * 5))}))
func on_button_3_press() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/level {level}.tscn".format({"level": str(3 + ((map - 1) * 5))}))
func on_button_4_press() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/level {level}.tscn".format({"level": str(4 + ((map - 1) * 5))}))
func on_button_5_press() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/level {level}.tscn".format({"level": str(5 + ((map - 1) * 5))}))

func change_map(value):
	remove_child($Map)
	map += value
	update()
