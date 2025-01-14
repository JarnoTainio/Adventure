extends Camera2D

@export var tilemap: TileMap

func _ready():
	var mapRect = tilemap.get_used_rect()
	var worldSize = mapRect.size * 16
	limit_right = worldSize.x
	limit_bottom = worldSize.y