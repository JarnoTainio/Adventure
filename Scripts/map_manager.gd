class_name MapManager extends TileMap

enum Direction {UP, DOWN, LEFT, RIGHT}

signal map_updated

@onready var player: Node2D = get_node("/root/World/Player")
@onready var monster_manager: MonsterManager = $MonsterManager

@export var tilemap: TileMap
@export var map_width: int = 2
@export var map_height: int = 2

@onready var chunk_pieces: Array = [
		preload("res://Scenes/Maps/plains_0.tscn"),
		preload("res://Scenes/Maps/plains_1.tscn"),
		preload("res://Scenes/Maps/plains_2.tscn")
	]
var chunk_size: int = 16

var map_pos: Vector2i = Vector2i.ZERO
var spawn_zones: Dictionary = {}

func _ready():
	generate_map()

func generate_map():
	monster_manager.remove_monsters()
	tilemap.clear()
	var seed_num = map_pos.x + map_pos.y * 1000
	seed(seed_num)
	for y in range(map_height):
		for x in range(map_width):
			var chunk_piece = chunk_pieces[randi() % chunk_pieces.size()]
			var offset = Vector2(x * chunk_size, y * chunk_size)
			copy_tiles(chunk_piece, offset)
			
			var monsters = randi() % 10 - 2
			for i in range(monsters):
				var spawn_key: Vector2i = spawn_zones.keys()[randi() % spawn_zones.size()]
				spawn_zones.erase(spawn_key)
				var _offset = Vector2i(randi() % 4, randi() % 4)
				var spawn = (spawn_key * 4 + _offset) * Vector.TILE_SIZE
				monster_manager.spawn_enemy(spawn)
			spawn_zones.clear()

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

				if i != 1: continue
				# Save valid spawn areas
				var spawn_zone = Vector2i(tile_pos.x / 4, tile_pos.y / 4)
				if !spawn_zones.has(spawn_zone) || spawn_zones[spawn_zone] == true:
					spawn_zones[spawn_zone] = atlas_coord == -Vector2i.ONE
					
	for zone in spawn_zones:
		if spawn_zones[zone] == false:
			spawn_zones.erase(zone)
	chunk_piece.queue_free()

func _on_area_exit_player_entered_exit(dir):
	var move_dir = Vector2i.ZERO
	if dir == Direction.UP:
		move_dir.y = 1
	elif dir == Direction.DOWN:
		move_dir.y = -1
	elif dir == Direction.LEFT:
		move_dir.x = 1
	elif dir == Direction.RIGHT:
		move_dir.x = -1
	map_pos += move_dir
	player.position += Vector2(
		move_dir.x * map_width * chunk_size * Vector.TILE_SIZE,
		move_dir.y * map_height * chunk_size * Vector.TILE_SIZE
	)
	player.position -= move_dir * float(Vector.TILE_SIZE)
	generate_map()
