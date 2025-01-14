class_name Collectible extends Area2D

@onready var sprite: Sprite2D = $Sprite2D
@export var item: ItemData

func _ready():
	sprite.texture = item.sprite

func collect(inventory: Inventory):
	inventory.add(item)
	queue_free()
