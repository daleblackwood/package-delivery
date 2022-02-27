extends KinematicBody
class_name Player

export var speed = 10.0
export var acceleration = 1.0
export var piss_duration = 15.0

var velocity = Vector3()
var direction = Vector3()
var model: MeshInstance
var piss_mats = []
var carriable: Carriable = null
var player_index = 0
var level: Spatial
var piss_time = 0.0
var is_draining = false
var is_enabled = true
var move_input = Vector3()


enum PlayerState { Init, Ready, Finished, Dead }
var state = PlayerState.Init


func _ready():
	model = find_node("Model")
	piss_mats = collect_piss_materials(self)
	
	
func collect_piss_materials(parent: Node, materials: Array = []) -> Array:
	if parent is MeshInstance:
		var material = (parent as MeshInstance).material_override as ShaderMaterial
		if material != null and material.shader != null:
			materials.append(material)
	for i in range(parent.get_child_count()):
		collect_piss_materials(parent.get_child(i), materials)
	return materials
	
	
func register_player(index: int, _level) -> void:
	player_index = index
	level = _level
	reset()
	
	
func reset():
	piss_time = 0.0
	move_input = Vector3()
	
	
func set_enabled(value: bool) -> void:
	if value == is_enabled:
		return
	set_process(value)
	is_enabled = value
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
	for piss_mat in piss_mats:
		piss_mat.set_shader_param("piss", pissv)
	if piss_time >= piss_duration:
		die_piss()
	var shake = pissv * 0.05
	model.transform.origin = Vector3(
		rand_range(-shake, shake),
		rand_range(-shake, shake),
		rand_range(-shake, shake)
	)
	
	
func die_piss() -> void:
	Game.level.instance("Piss", global_transform.origin)
	print("pissed")
	state = PlayerState.Dead
	carriable_drop()
	
		
func process_input() -> void:
	var input = Inputs.get_player_input(player_index)
	var cam = get_viewport().get_camera()
	var cam_right = cam.global_transform.basis.x
	var cam_forward = cam_right.cross(Vector3.UP)
	move_input = cam_right * input.move.x - cam_forward * input.move.y
	if input.use_now:
		if carriable != null:
			if carriable.carrier != self:
				carriable_carry()
			else:
				carriable_drop()

	
func carriable_carry() -> void:
	if carriable == null:
		return
	if carriable.carrier == self:
		return
	carriable.carry(self)
	
	
func carriable_drop() -> void:
	if carriable == null:
		return
	if carriable.carrier != self:
		return
	carriable.drop(global_transform.origin + direction * 2.0)
	

func _physics_process(delta):
	var wish_vel = move_input * speed
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
	if carriable == null:
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
