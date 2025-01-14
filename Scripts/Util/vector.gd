extends Node

func vector_to_dir_string(vector: Vector2) -> String:
	var dir = "down"
	if vector.y < 0: dir = "up"
	elif vector.x > 0: dir = "right"
	elif vector.x < 0: dir = "left"
	return dir