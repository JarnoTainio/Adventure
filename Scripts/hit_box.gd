class_name HitBox extends Area2D


func _ready():
  collision_layer = 4
  collision_mask = 0

func enable(is_enabled: bool = true):
  if is_enabled:
    collision_layer = 4
  else:
    collision_layer = 0