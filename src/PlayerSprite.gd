extends Sprite2D

func check_mask(flipped: bool):
	
	for child in get_parent().get_children():
		if child.name.contains("@"):
			get_parent().remove_child(child)
		
	
	var data = texture.get_image()
	var bitmap: = BitMap.new()
	
	bitmap.create_from_image_alpha(data)
	var polys = bitmap.opaque_to_polygons(
		Rect2(
			Vector2.ZERO,
			texture.get_size()
		),
		15
	)
	for poly in polys:
		var collision_polygon = CollisionPolygon2D.new()
		collision_polygon.polygon = poly
		if flipped:
			collision_polygon.scale.x = -1
			collision_polygon.position.x += texture.get_width()
		get_parent().add_child(collision_polygon)
