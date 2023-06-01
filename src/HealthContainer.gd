extends HBoxContainer

var heart_full = preload("res://assets/hudHeart_full.png")
var heart_empty = preload("res://assets/hudHeart_empty.png")
var heart_half = preload("res://assets/hudHeart_half.png")

func update_partial(value):
	for i in self.get_child_count():
		if value > i * 2 + 1:
			get_child(i).texture = heart_full
		elif value > i * 2:
			get_child(i).texture = heart_half
		else:
			get_child(i).texture = heart_empty
