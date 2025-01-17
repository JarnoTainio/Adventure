class_name HurtBox extends Area2D

signal hit_by_attack(attack: Attack)

@export var remember_areas: bool = false

var colliders: Array[Area2D] = []

func _ready():
	monitoring = true
	monitorable = false
	collision_mask = 4
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)
	

# Signals

func _on_area_entered(area: HitBox):
	if area == null: return
	if owner.name == area.owner.name: return
	
	var attack = to_attack(area)
	hit_by_attack.emit(attack)
	if remember_areas: colliders.append(area)

func _on_area_exited(area: HitBox):
	if remember_areas: colliders.erase(area)

# Functions

func to_attack(area: Area2D) -> Attack:
	var attack = Attack.new()
	attack.damage = 1
	attack.velocity = area.owner.velocity
	attack.knockback = 10
	return attack

func get_attack() -> Attack:
	if colliders.size() == 0: return null
	return to_attack(colliders[0])
