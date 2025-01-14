class_name Inventory extends Resource

signal updated

@export var items: Array[ItemData]

func add(item: ItemData) -> bool:
  for i in range(items.size()):
    if items[i]: continue
    items[i] = item
    updated.emit()
    return true
  return false