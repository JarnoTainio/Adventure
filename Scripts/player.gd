class_name Player extends Creature

signal health_changed(current_health: int)

@onready var effects = $EffectPlayer
@onready var hurtTimer: Timer = $HurtTimer
@onready var hurtBox: HurtBox = $HurtBox
@onready var interactMarker: Sprite2D = $InteractMarker
@onready var weapon = $Weapon
@onready var state_machine = $StateMachine

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
	animation = $AnimationPlayer
	effects.play("RESET")
	weapon.visible = false
	interactMarker.visible = false
	state_machine._initialize()

func _process(delta):
	handle_input(delta)
	state_machine._process(delta)

func _physics_process(_delta: float):
	update_indicator()
	move_and_slide()


func handle_input(delta: float):
	if !can_move: return
	
	# Movement
	var move_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = move_direction * move_speed * delta
	
	# Interacting
	if is_collecting: collect_timer -= delta


func attack():
	animation.play("attack_" + last_dir)
	is_attacking = true
	weapon.visible = true
	await animation.animation_finished
	is_attacking = false
	weapon.visible = false


func set_animation(state: String):
	if velocity != Vector2.ZERO:
		last_dir = Vector.vector_to_dir_string(velocity)
	animation.play(state + "_" + last_dir)

func stop_animation():
	animation.stop()

func update_indicator():
	if target_item != null:
		interactMarker.global_position = target_item.global_position + Vector2(0, -4)

func _on_hurt_box_hit_by_attack(_attack: Attack):
	take_damage(_attack.damage)
	knockback(_attack.knockback, _attack.velocity)


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
	var _attack = hurtBox.get_attack()
	if _attack != null: _on_hurt_box_hit_by_attack(_attack)


func knockback(power: int, hit_velocity: Vector2):
	var knockback_dir = (hit_velocity - velocity).normalized()
	velocity = knockback_dir * power * 100
	move_and_slide()


func _input(event):
	if state_machine.handle_input(event): return
	if event.is_action_pressed("space"):
		if target_item == null: return
		target_item.collect(inventory)


func _on_interact_box_closest_changed(closest: Area2D):
	is_collecting = false
	collect_timer = 0.0
	target_item = closest
	interactMarker.visible = target_item != null
