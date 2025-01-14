class_name Player extends CharacterBody2D

signal health_changed(current_health: int)

@onready var animation = $AnimationPlayer
@onready var effects = $EffectPlayer
@onready var hurtTimer: Timer = $HurtTimer
@onready var hurtBox: HurtBox = $HurtBox
@onready var interactMarker: Sprite2D = $InteractMarker
@onready var weapon = $Weapon

@onready var inventory: Inventory = preload("res://Resources/inventory_player.tres")

@export var move_speed: int = 30
@export var max_health: int = 12

# Movement
var can_move: bool = true
var last_dir: String = "down"

# State
var current_health: int
var is_attacking: bool = false

# Enviroment
var target_item: Area2D
var is_collecting: bool
var collect_timer: float

func _ready():
	current_health = max_health
	effects.play("RESET")
	weapon.visible = false
	interactMarker.visible = false


func _physics_process(delta: float):
	handle_input(delta)
	move_and_slide()
	update_animation()
	update_indicator()


func handle_input(delta: float):
	if !can_move: return
	
	# Movement
	var move_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = move_direction * move_speed * delta
	
	# Interacting
	if is_collecting: collect_timer -= delta

	# Combat
	if Input.is_action_just_pressed("Attack"):
		perform_attack()


func perform_attack():
	animation.play("attack_" + last_dir)
	is_attacking = true
	weapon.visible = true
	await animation.animation_finished
	is_attacking = false
	weapon.visible = false


func update_animation():
	if is_attacking: return
	if velocity.length() == 0:
		animation.stop()
		return
	last_dir = Vector.vector_to_dir_string(velocity)
	animation.play("move_" + last_dir)


func update_indicator():
	if target_item != null:
		interactMarker.global_position = target_item.global_position + Vector2(0, -4)

func _on_hurt_box_hit_by_attack(attack: Attack):
	take_damage(attack.damage)
	knockback(attack.knockback, attack.velocity)


func take_damage(damage: int):
	if hurtTimer.time_left > 0: return
	current_health -= damage
	effects.play("hurt_blink")
	hurtTimer.start()

	health_changed.emit(current_health)
	if current_health <= 0:
		get_tree().quit()

	await hurtTimer.timeout
	effects.play("RESET")
	var attack = hurtBox.get_attack()
	if attack != null: _on_hurt_box_hit_by_attack(attack)


func knockback(power: int, hit_velocity: Vector2):
	var knockback_dir = (hit_velocity - velocity).normalized()
	velocity = knockback_dir * power * 100
	move_and_slide()


func _input(event):
	if event.is_action_pressed("space"):
		if target_item == null: return
		target_item.collect(inventory)


func _on_interact_box_closest_changed(closest: Area2D):
	is_collecting = false
	collect_timer = 0.0
	target_item = closest
	interactMarker.visible = target_item != null
