extends CharacterBody3D

@onready var stateprint = $"../Stage/Camera3D/debug text/stateinfo"
@onready var inputprint = $"../Stage/Camera3D/debug text/input info"
const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


var state_machine: LimboHSM

func _ready():
	initate_state_machine()

#walking left and right couldnt get it to work with multiple control layouts
func _physics_process(delta):
	stateprint.text = str(state_machine.get_active_state())
	var dir = Input.get_action_strength("right") - Input.get_action_strength("left")
	if dir:
		velocity.x = dir * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	
	move_and_slide()
#creates main state machine (state_machine) makes the state machine a child of the character body, then makes vars of the states, and then initializes it and makes sure it is active.
func initate_state_machine():
	state_machine = LimboHSM.new()
	add_child(state_machine)
	
	#creating vars for each state
	var idle_state = LimboState.new().named("idle").call_on_enter(idle_start).call_on_update(idle_update)
	var walk_state = LimboState.new().named("walk").call_on_enter(walk_start).call_on_update(walk_update)
	var jump_state = LimboState.new().named("jump").call_on_enter(jump_start).call_on_update(jump_update)
	var crouch_state = LimboState.new().named("crouch").call_on_enter(crouch_start).call_on_update(crouch_update)
	
	#puts them inside the actual state machine
	state_machine.add_child(idle_state)
	state_machine.add_child(walk_state)
	state_machine.add_child(jump_state)
	state_machine.add_child(crouch_state)
	
	#makes the idle state the initial state
	state_machine.initial_state = idle_state
	
	#transitioning between states
	state_machine.add_transition(idle_state, walk_state, &"to_walk")
	state_machine.add_transition(state_machine.ANYSTATE, idle_state, &"state_ended")
	
	state_machine.initialize(self)
	state_machine.set_active(true)

#functions for starting and updating the states
func idle_start():
	pass

func idle_update(delta: float):
	if velocity.x != 0:
		state_machine.dispatch(&"to_walk")
	

func walk_start():
	pass

func walk_update(delta: float):
	if velocity.x == 0:
		state_machine.dispatch(&"state_ended")

func jump_start():
	pass

func jump_update(delta: float):
	pass

func crouch_start():
	pass

func crouch_update(delta: float):
	pass
