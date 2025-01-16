class_name PlayerWalkState extends State

func enter():
	creature.set_animation("move")

func tick(_delta: float):
	if creature.velocity.length() == 0:
		return state_machine.states["Idle"]
	creature.set_animation("move")

func handle_input(_event: InputEvent):
	if Input.is_action_just_pressed("Attack"):
		return state_machine.states["Attack"]