class_name InventoryManager extends Control

@onready var slotPrefab = preload("res://Scenes/UI/inventory_slot.tscn")
@onready var inventory: Inventory = preload("res://Resources/inventory_player.tres")
@onready var slotContainer = $NinePatchRect/GridContainer

var is_open: bool = false

func _ready():
	inventory.updated.connect(update)
	for i in inventory.items.size():
		var slot = slotPrefab.instantiate()
		slotContainer.add_child(slot)
	update()
	close()

func update():
	var slots = slotContainer.get_children()
	for i in slots.size():
		(slots[i] as InventorySlot).update(inventory.items[i])

func open():
	is_open = true
	visible = true
	update()

func close():
	is_open = false
	visible = false
