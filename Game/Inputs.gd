extends Node


class PlayerInput:
	var move = Vector2()
	var jump_hold = false
	var jump_now = false
	var use_hold = false
	var use_now = false
	
	func _init():
		reset()
	
	func reset():
		move = Vector2()
		jump_hold = true
		jump_now = false
		use_hold = true
		use_now = false
		
	func is_any_action_now() -> bool:
		return jump_now or use_now


var DUMMY_INPUT = PlayerInput.new()

const KEY_MAPPINGS = [
	[KEY_LEFT, KEY_RIGHT, KEY_UP, KEY_DOWN, KEY_SPACE, KEY_SHIFT],
	[KEY_A, KEY_D, KEY_W, KEY_S, KEY_F, KEY_E]
]

const USE_BUTTONS = [0, 1]

var inputs = []
var joysticks = []
var is_discovering = false


func _process(delta: float) -> void:
	while inputs.size() < Game.player_count:
		inputs.append(PlayerInput.new())
	while inputs.size() > Game.player_count:
		inputs.remove(inputs.size() - 1)
	for i in range(inputs.size()):
		process_input(inputs[i], i)
	
	if is_discovering:
		var jids = Input.get_connected_joypads()
		for jid in jids:
			if joysticks.has(jid):
				continue
			for btn in USE_BUTTONS:
				if Input.is_joy_button_pressed(jid, btn):
					joysticks.append(jid)
					for i in range(inputs.size()):
						inputs[i].reset()
			
		
		
func set_discovery(on: bool) -> void:
	is_discovering = on
	if on:
		joysticks = []

		
func process_input(input: PlayerInput, player_index: int) -> void:
	input.move.x = 0.0
	input.move.y = 0.0
	var want_use = false
	var want_jump = false
	var mapping = KEY_MAPPINGS[player_index] if player_index >= 0 and player_index < KEY_MAPPINGS.size() else null
	if mapping:
		if Input.is_key_pressed(mapping[0]):
			input.move.x -= 1.0
		if Input.is_key_pressed(mapping[1]):
			input.move.x += 1.0
		if Input.is_key_pressed(mapping[2]):
			input.move.y += 1.0
		if Input.is_key_pressed(mapping[3]):
			input.move.y -= 1.0
		if input.move.length_squared() > 1.0:
			input.move = input.move.normalized()		
		if Input.is_key_pressed(mapping[4]) or Input.is_key_pressed(mapping[5]):
			want_use = true
		
	if player_index < joysticks.size():
		var jid = joysticks[player_index]
		input.move.x += Input.get_joy_axis(jid, 0)
		input.move.y -= Input.get_joy_axis(jid, 1)
		for btn in USE_BUTTONS:
			if Input.is_joy_button_pressed(jid, btn):
				want_use = true
	
	input.jump_now = want_jump and not input.jump_hold
	input.jump_hold = want_jump
	input.use_now = want_use and not input.use_hold
	input.use_hold = want_use
	
	
	
func get_player_input(player_index: int) -> PlayerInput:
	if player_index < 0 or player_index >= inputs.size():
		return DUMMY_INPUT
	return inputs[player_index]
	
	
func is_any_use() -> bool:
	for input in inputs:
		if input.use_now:
			return true
	return false
	

func is_any_jump() -> bool:
	for input in inputs:
		if input.jump_now:
			return true
	return false
	
	
func is_any_action() -> bool:
	return is_any_use() or is_any_jump()
	
	
func get_all_axes() -> Vector2:
	var result = Vector2()
	for input in inputs:
		result += input.move
	if result.length_squared() > 1.0:
		result = result.normalized()
	return result
