extends TileMap

signal map_updated

@export var tilemap: TileMap
@export var map_width: int = 2
@export var map_height: int = 2

@onready var chunk_pieces: Array = [
		preload("res://Scenes/Maps/plains_0.tscn"),
		preload("res://Scenes/Maps/plains_1.tscn"),
		preload("res://Scenes/Maps/plains_2.tscn")
	]
var chunk_size: int = 16

func _ready():
	tilemap.clear()
	generate_map()

func generate_map():
	for y in range(map_height):
		for x in range(map_width):
			var chunk_piece = chunk_pieces[randi() % chunk_pieces.size()]
			var offset = Vector2(x * chunk_size, y * chunk_size)
			copy_tiles(chunk_piece, offset)

	map_updated.emit()

func copy_tiles(chunk_prefab: PackedScene, offset: Vector2):
	var chunk_piece: TileMap = chunk_prefab.instantiate()
	for y in range(chunk_size):
		for x in range(chunk_size):
			var pos = Vector2(x, y)
			var tile_pos = offset + pos
			for i in range(2): # Layers
				var source_id = chunk_piece.get_cell_source_id(i, pos)
				var atlas_coord = chunk_piece.get_cell_atlas_coords(i, pos)
				tilemap.set_cell(i, tile_pos, source_id, atlas_coord)
	chunk_piece.queue_free()
