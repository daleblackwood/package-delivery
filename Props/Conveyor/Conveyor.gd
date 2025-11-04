extends Node3D

var model: MeshInstance3D
var area: Area3D
var mat: StandardMaterial3D
var time = 0.0
var bodies = []


func _ready() -> void:
	model = find_child("Model")
	area = find_child("Area3D")
	area.connect("body_entered", Callable(self, "on_body_enter"))
	area.connect("body_exited", Callable(self, "on_body_exit"))
	
	
func _physics_process(delta):
	time += delta	
	var mat := model.get_active_material(0)
	if mat:
		mat.uv1_offset = Vector3(0.0, time * 3.0, 0.0)
		for body in bodies:
			var speed = 2.0 / body.get_meta("conveyor_count")
			body.set_velocity(global_transform.basis.z * -speed)
			body.set_up_direction(Vector3.UP)
			body.move_and_slide()
			body.velocity


func on_body_enter(body: Node3D) -> void:
	if body is CharacterBody3D == false:
		return
	if bodies.has(body):
		return
	body.set_meta("conveyor_count", 1 if not body.has_meta("conveyor_count") else body.get_meta("conveyor_count") + 1)
	bodies.append(body)
	
	
func on_body_exit(body: Node3D) -> void:
	if body is CharacterBody3D == false:
		return
	var index = bodies.find(body)
	if index < 0:
		return
	body.set_meta("conveyor_count", body.get_meta("conveyor_count") - 1)
	bodies.remove_at(index)
