class_name HurtBox extends Area2D

signal hit_by_attack(attack: Attack)

@export var remember_areas: bool = false

var colliders: Array[Area2D] = []

func _on_area_entered(area: HitBox):
	print_debug("hurt_box " + get_parent().name + " hit: ")
	if area == null: return
	
	# var attack = to_attack(area)
	# hit_by_attack.emit(attack)
	# if remember_areas: colliders.append(area)

func _on_area_exited(area: Area2D):
	if area.name != "HitBox": return
	if remember_areas: colliders.erase(area)

func to_attack(area: Area2D) -> Attack:
	var attack = Attack.new()
	attack.damage = 1
	attack.velocity = area.get_parent().velocity
	attack.knockback = 10
	return attack

func get_attack() -> Attack:
	if colliders.size() == 0: return null
	return to_attack(colliders[0])
