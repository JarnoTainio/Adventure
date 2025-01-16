class_name PlayerIdleState extends State

func enter():
	creature.set_animation("move")
	creature.stop_animation()

func tick(_delta: float):
	if creature.velocity.length() > 0:
		return state_machine.states["Walk"]

func handle_input(_event: InputEvent):
	if Input.is_action_just_pressed("Attack"):
		return state_machine.states["Attack"]
