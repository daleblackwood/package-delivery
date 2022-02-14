extends Node


class PlayerInput:
	var move = Vector2()
	var jump_hold = false
	var jump_now = false
	var use_hold = false
	var use_now = false
	
	func reset():
		move = Vector2()
		jump_hold = false
		jump_now = false
		use_hold = false
		use_now = false
		
	func is_any_action_now() -> bool:
		return jump_now or use_now


var DUMMY_INPUT = PlayerInput.new()

var KEY_MAPPINGS = [
	[KEY_LEFT, KEY_RIGHT, KEY_UP, KEY_DOWN, KEY_SPACE],
	[KEY_A, KEY_D, KEY_W, KEY_S, KEY_F]
]

var inputs = []
var joysticks = []

func _ready():
	reset_joysticks()
	
	
func reset_joysticks():
	joysticks = Input.get_connected_joypads()


func _process(delta: float) -> void:
	while inputs.size() < Game.player_count:
		inputs.append(PlayerInput.new())
	while inputs.size() > Game.player_count:
		inputs.remove(inputs.size() - 1)
	for i in range(inputs.size()):
		process_input(inputs[i], i)
	

		
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
		want_use = Input.is_key_pressed(mapping[4])
		
	if player_index < joysticks.size():
		var jid = joysticks[player_index]
		input.move.x += Input.get_joy_axis(jid, 0)
		input.move.y -= Input.get_joy_axis(jid, 1)
		if Input.is_joy_button_pressed(jid, 0) or Input.is_joy_button_pressed(jid, 2):
			want_use = true
		if Input.is_joy_button_pressed(jid, 1) or Input.is_joy_button_pressed(jid, 3):
			want_jump = true
	
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
