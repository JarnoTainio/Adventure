@tool
class_name ExitArea extends Area2D

enum Direction {UP, DOWN, LEFT, RIGHT}

signal player_entered_exit(dir: Direction)

@onready var collision_shape = $CollisionShape2D
@onready var map_manager: MapManager = get_node("/root/World/MapManager")

@export var direction: Direction:
	set(_d):
		direction = _d
		_update_area()

@export var size: int = 2:
	set(_v):
		size = _v
		_update_area()
		

func _ready():
	player_entered_exit.connect(map_manager._on_area_exit_player_entered_exit)
	_update_position()
	_update_area()

func _update_position():
	var tile_size: int = Vector.TILE_SIZE
	var width: int = map_manager.map_width
	var height: int = map_manager.map_height
	var chunk_size: int = map_manager.chunk_size
	
	if direction == Direction.UP:
		position = Vector2(
			width * chunk_size * tile_size / 2.0,
			0
		)
	elif direction == Direction.DOWN:
		position = Vector2(
			width * chunk_size * tile_size / 2.0,
			height * chunk_size * tile_size
		)
	elif direction == Direction.LEFT:
		position = Vector2(
			0,
			height * chunk_size * tile_size / 2.0
		)
	elif direction == Direction.RIGHT:
		position = Vector2(
			width * chunk_size * tile_size,
			height * chunk_size * tile_size / 2.0
		)


func _update_area():
	if collision_shape == null:
		return
		# collision_shape = $CollisionShape2D

	var new_rect: Vector2 = Vector2(16, 16)
	var new_pos: Vector2 = Vector2.ZERO

	if direction == Direction.UP:
		new_rect.x *= size
		new_pos.y -= 8
	elif direction == Direction.DOWN:
		new_rect.x *= size
		new_pos.y += 8
	elif direction == Direction.LEFT:
		new_rect.y *= size
		new_pos.x -= 8
	elif direction == Direction.RIGHT:
		new_rect.y *= size
		new_pos.x += 8
		
	collision_shape.shape.size = new_rect
	collision_shape.position = new_pos

func _on_body_entered(body):
	if body == null: return
	if body.name != "Player": return
	player_entered_exit.emit(direction)
