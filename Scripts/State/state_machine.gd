class_name StateMachine extends Node2D

@export var creature: Creature

var current_state: State
var states: Dictionary = {}

func _initialize():
	creature = owner

	for state in get_children():
		if state is State:
			state.init(self, creature)
			states[state.name] = state
			if current_state == null:
				set_state(state)

	current_state.enter()

func _process(_delta: float):
	if current_state == null: return
	
	var new_state = current_state.tick(_delta)
	if new_state != null: set_state(new_state)

func handle_input(event: InputEvent):
	set_state(current_state.handle_input(event))

func set_state(state: State):
	if state == null: return
	print(state.name)

	if current_state != null:
		current_state.exit()
	current_state = state
	current_state.enter()
