class_name Slime extends CharacterBody2D

@onready var item_prefab = preload("res://Scenes/Items/collectible.tscn")
@onready var animation = $AnimationPlayer

@export var data: EnemyData = preload("res://Resources/Enemies/eney_slime.tres")
@export var move_speed: int = 30
var limit: float = 0.5

@export var start_position: Vector2
@export var end_position: Vector2

var is_dead = false

func _ready():
	start_position = position
	end_position = start_position + end_position * 16
	animation.play("RESET")


func _physics_process(delta):
	if is_dead: return
	handle_movement(delta)
	move_and_slide()
	update_animation()


func change_direction():
	var temp = end_position;
	end_position = start_position
	start_position = temp


func handle_movement(delta):
	var move_dir = end_position - position
	if move_dir.length() < limit:
		change_direction()
	velocity = move_dir.normalized() * delta * move_speed


func update_animation():
	if velocity.length() == 0:
		animation.stop()
		return

	var dir = Vector.vector_to_dir_string(velocity)
	animation.play("move_" + dir)


func die():
	is_dead = true
	animation.play("death")
	await animation.animation_finished
	if data.loot_common: spawn_item()
	queue_free()

func spawn_item():

	# Randomize the item
	var itemData: ItemData
	var roll = randf() * 100
	if roll < 20:
		itemData = data.loot_rare
	elif roll < 40:
		itemData = data.loot_common
	else: return
	
	var item: Collectible = item_prefab.instantiate()
	item.item = itemData
	item.global_position = global_position
	
	var items_node = get_tree().root.get_node("World/TileMap/Items")
	items_node.add_child(item)

# SIGNALS

func _on_hurt_box_hit_by_attack(_attack: Attack):
	die()