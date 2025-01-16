class_name MonsterManager extends Node2D

@onready var slime_prefab = preload("res://Scenes/Creatures/Enemies/slime.tscn")

func spawn_enemy(pos: Vector2):
  var enemy = slime_prefab.instantiate()
  enemy.position = pos
  add_child(enemy)

func remove_monsters():
  for monster in get_children():
    monster.queue_free()
