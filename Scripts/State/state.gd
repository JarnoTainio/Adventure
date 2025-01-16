class_name State extends Node

static var state_machine: StateMachine
static var creature: Creature

func init(_state_machine: StateMachine, _creature: Creature):
	state_machine = _state_machine
	creature = _creature

func enter():
	pass

func exit():
	pass

func tick(_delta: float):
	pass