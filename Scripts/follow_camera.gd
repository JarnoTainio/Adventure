extends Camera2D

@export var tilemap: TileMap

func _ready():
	update_limits()

func update_limits():
	var mapRect = tilemap.get_used_rect()
	var worldSize = mapRect.size * 16
	limit_right = worldSize.x
	limit_bottom = worldSize.y

func _on_tile_map_map_updated():
	update_limits()
