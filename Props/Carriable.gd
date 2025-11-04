extends Area3D
class_name Carriable

var model: MeshInstance3D
var body: CharacterBody3D
var carrier: CharacterBody3D
var drop_pos: Vector3
var drop_time = 0.0
var is_carriable = false
var time = 0.0

func _ready():
	body = get_parent() as CharacterBody3D
	if body == null:
		print("Carriable needs kinematic parent")
	else:
		connect("body_entered", Callable(self, "on_body_entered"))
		connect("body_exited", Callable(self, "on_body_exited"))
		is_carriable = true
		body.set_meta("carriable", self)
	model = find_child("Model")


func carry(new_carrier: CharacterBody3D):
	carrier = new_carrier
	set_physics_process(true)
	is_carriable = false
	
	
func drop(pos: Vector3):
	drop_pos = pos
	drop_time = 0.0
	carrier = null
	is_carriable = true
	
	
func _physics_process(delta):
	time += delta
	if carrier != null:
		var to = carrier.global_transform.origin + Vector3.UP * (3.2 + sin(time * 10.0) * 0.1)
		var dif = to - body.global_transform.origin
		body.set_velocity(dif * 30.0)
		body.set_up_direction(Vector3.UP)
		body.move_and_slide()
		body.velocity
	elif drop_pos != Vector3.ZERO:
		drop_time += delta
		var dif = drop_pos - body.global_transform.origin
		if dif.length_squared() < 0.1 or drop_time > 0.5:
			drop_pos = Vector3.ZERO
			body.move_and_collide(dif)
		body.set_velocity(dif * 20.0)
		body.set_up_direction(Vector3.UP)
		body.move_and_slide()
		body.velocity
	elif not body.is_on_floor():
		body.set_velocity(Vector3.DOWN * 5.0)
		body.move_and_slide()
		body.velocity
	else:
		set_physics_process(false)
	

func on_body_entered(body: Node) -> void:
	if not is_carriable:
		return
	if not body is CharacterBody3D:
		return
	if not body.has_method("set_carriable"):
		return
	body.call_deferred("set_carriable", self)
	
	
func on_body_exited(body: Node) -> void:
	if not is_carriable:
		return
	if not body is CharacterBody3D:
		return
	if not body.has_method("unset_carriable"):
		return
	body.call_deferred("unset_carriable", self)
