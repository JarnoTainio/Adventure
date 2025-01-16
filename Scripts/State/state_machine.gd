class_name StateMachine extends Node2D

@export var creature: Creature

var current_state: State
var states: Dictionary = {}

func _initialize():
	creature = owner
	if creature == null:
		push_error("State machine has no owner!")
		return

	for state in get_children():
		if state is State:
			state.init(self, creature)
			states[state.name] = state
			if current_state == null:
				set_state(state.name)

	if current_state != null:
		current_state.enter()
	else:
		push_error("No states found!")

func _process(_delta: float):
	if current_state == null: return
	
	var new_state = current_state.tick(_delta)
	if new_state != null: set_state(new_state)

func set_state(state_name: String):
	if !states.has(state_name):
		push_error("State not found: " + state_name + "!")
		return

	if current_state != null:
		current_state.exit()
	current_state = states[state_name]
	current_state.enter()
