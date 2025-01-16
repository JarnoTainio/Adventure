class_name StatePlayerAttack extends State

var is_attacking: bool = false

func enter():
	print("ATTACK")
	creature.set_animation("attack")
	creature.attack()
	is_attacking = true
	await creature.animation.animation_finished
	is_attacking = false


func tick(_delta: float):
	if !is_attacking:
		print("Attack over")
		return state_machine.states["Idle"]