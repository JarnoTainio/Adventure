class_name UIHeart extends Panel

@onready var sprite = $Sprite2D

func update(value: int):
	if value >= 4:
		sprite.frame = 4
	elif value < 0:
		sprite.frame = 0
	else:
		sprite.frame = value