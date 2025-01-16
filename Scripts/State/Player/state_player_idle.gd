class_name PlayerIdleState extends State

func enter():
	creature.set_animation("idle")

func exit():
	pass

func tick(_delta: float):
	if creature.velocity.length() > 0:
		return "Walk"
