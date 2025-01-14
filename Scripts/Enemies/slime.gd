class_name Slime extends CharacterBody2D

@onready var animation = $AnimationPlayer

@export var move_speed: int = 30
var limit: float = 0.5

@export var start_position: Vector2
@export var end_position: Vector2

func _ready():
	start_position = position
	end_position = start_position + end_position * 16

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

func _physics_process(delta):
	handle_movement(delta)
	move_and_slide()
	update_animation()


func _on_hurt_box_hit_by_attack(attack: Attack):
	print("Slime auch: ", attack)
	if attack.source == name: return
	queue_free()
