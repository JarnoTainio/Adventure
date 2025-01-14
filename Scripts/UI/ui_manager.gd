class_name UIManager extends CanvasLayer

signal ui_is_open(is_open: bool)

@onready var inventory = $Inventory

func _input(event):
	if event.is_action_pressed("toggle_inventory"):
		toggle_inventory()

func toggle_inventory():
	if inventory.is_open:
		inventory.close()
	else:
		inventory.open()
	ui_is_open.emit(inventory.is_open)