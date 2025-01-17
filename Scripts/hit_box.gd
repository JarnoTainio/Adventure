class_name HitBox extends Area2D


func _ready():
  monitoring = false
  monitorable = true
  collision_layer = 4

func enable(is_enabled: bool = true):
  set_deferred("monitorable", is_enabled)