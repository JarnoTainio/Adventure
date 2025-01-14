class_name InventorySlot extends Panel

@onready var itemSprite: Sprite2D = $ItemSprite

func update(item: ItemData):
	itemSprite.visible = item != null
	if item == null: return
	
	itemSprite.visible = true
	itemSprite.texture = item.sprite
