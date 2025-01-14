extends Area2D

signal closest_changed(closest: Area2D)

var objects: Array[Area2D] = []
var closest: Area2D

var counter: float = 0.2

func _physics_process(delta):
	counter -= delta
	if counter > 0: return
	update()

func update():
	counter = 0.2
	if objects.is_empty():
		if closest != null: closest_changed.emit(null)
		closest = null
		return
	var best: Area2D = null
	var closest_distance: float
	
	for area in objects:
		var distance = global_position.distance_to(area.global_position)
		if best == null || distance < closest_distance:
			closest_distance = distance
			best = area
	
	if best == closest: return
	closest = best
	closest_changed.emit(closest)

func _on_area_entered(area: Area2D):
	if !area.has_method("collect"): return
	objects.append(area)
	update()

func _on_area_exited(area: Area2D):
	if !area.has_method("collect"): return
	objects.erase(area)
	update()
