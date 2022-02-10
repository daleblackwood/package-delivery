extends KinematicBody
class_name Player

export var speed = 10.0
export var acceleration = 1.0
export var piss_duration = 15.0

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
	
var input: PlayerInput = null
var velocity = Vector3()
var direction = Vector3()
var model: MeshInstance
var material: ShaderMaterial
var carriable: Carriable = null
var player_index = 0
var level: Spatial
var piss_time = 0.0
var is_draining = false


enum PlayerState { Init, Ready, Finished, Dead }
var state = PlayerState.Init

func _ready():
	input = PlayerInput.new()
	model = find_node("Model")
	material = model.material_override as ShaderMaterial
	
	
func register_player(index: int, _level) -> void:
	player_index = index
	level = _level
	reset()
	
	
func reset():
	input.reset()
	piss_time = 0.0
	
	
func set_enabled(value: bool) -> void:
	set_process(value)
	reset()
	
	
func _process(delta: float) -> void:
	if state >= PlayerState.Finished:
		reset()
		return
	process_input()
	process_piss(delta)
		
		
func process_piss(delta: float) -> void:
	if is_draining:
		piss_time -= delta * 10.0
		if piss_time < 0.0:
			piss_time = 0.0
			is_draining = false
	else:
		piss_time += delta
	var pissv = clamp(piss_time / piss_duration, 0.0, 1.0)
	material.set_shader_param("piss", pissv)
	if piss_time >= piss_duration:
		print("pissed")
		state = PlayerState.Dead
	var shake = pissv * 0.05
	model.transform.origin = Vector3(
		rand_range(-shake, shake),
		rand_range(-shake, shake),
		rand_range(-shake, shake)
	)
	
		
func process_input() -> void:
	input.move.x = 0.0
	input.move.y = 0.0
	if Input.is_key_pressed(KEY_LEFT):
		input.move.x -= 1.0
	if Input.is_key_pressed(KEY_RIGHT):
		input.move.x += 1.0
	if Input.is_key_pressed(KEY_UP):
		input.move.y += 1.0
	if Input.is_key_pressed(KEY_DOWN):
		input.move.y -= 1.0
	if input.move.length_squared() > 1.0:
		input.move = input.move.normalized()
		
	var want_jump = Input.is_key_pressed(KEY_SPACE)
	var want_use = Input.is_key_pressed(KEY_SHIFT) or want_jump
	
	input.jump_now = want_jump and not input.jump_hold
	input.jump_hold = want_jump
	input.use_now = want_use and not input.use_hold
	input.use_hold = want_use
	
	if input.use_now:
		if carriable != null:
			if carriable.is_carriable:
				carriable.carry(self)
			else:
				carriable.drop(global_transform.origin + direction * 2.0)
				carriable = null


func _physics_process(delta):
	var wish_vel = Vector3()
	wish_vel.x = input.move.x
	wish_vel.z = -input.move.y
	wish_vel *= speed
	if wish_vel.length_squared() > speed:
		wish_vel = wish_vel.normalized() * speed
		
	var max_add = acceleration * delta * 50.0
	var vel_add = wish_vel - velocity
	if vel_add.length_squared() > max_add:
		vel_add = vel_add.normalized() * max_add
		
	velocity += vel_add
	var velsq = velocity.length_squared()
	if velsq > 0.1:
		direction = velocity
		direction.y = 0
		direction = velocity.normalized()
	if velsq > 0.0:
		move_and_slide(velocity, Vector3.UP)
	
	var look_dir = lerp(model.global_transform.basis.z, direction, 0.5)
	model.look_at(model.global_transform.origin - look_dir, Vector3.UP)
	
	
func set_carriable(obj: Carriable) -> void:
	if carriable == null or carriable.carrier != self:
		carriable = obj
		
		
func unset_carriable(obj: Carriable) -> void:
	if obj == carriable:
		carriable = null
		
		
func lift_enter(lift: Spatial) -> void:
	state = PlayerState.Finished
	
	
func drain_piss() -> void:
	if not can_piss():
		return
	is_draining = true
	
	
func can_piss() -> bool:
	return not is_draining and (carriable == null or carriable.carrier != self)
