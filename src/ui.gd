extends Control

@onready var coins_label: Label = get_node("Info Panel/Info Container/Top Info container/Coins Info Container/Conis label")
@onready var throwables_label: Label = get_node("Info Panel/Info Container/Top Info container/Throwables Info Container/Throwables label")

func _ready():
	PlayerData.connect("coins_in_level_updated", update_interface)
	PlayerData.connect("throwables_number_update", update_interface)

func update_interface() -> void:
	coins_label.text = str(PlayerData.coins_in_level)
	throwables_label.text = str(get_parent().get_parent().get_node("Player").throwables)
