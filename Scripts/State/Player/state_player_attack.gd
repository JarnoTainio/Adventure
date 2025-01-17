class_name StatePlayerAttack extends State

var is_attacking: bool = false

func enter():
	creature.set_animation("attack")
	creature.attack()
	is_attacking = true
	await creature.animation.animation_finished
	is_attacking = false

func exit():
	is_attacking = false

func tick(_delta: float):
	if !is_attacking:
		return state_machine.states["Idle"]