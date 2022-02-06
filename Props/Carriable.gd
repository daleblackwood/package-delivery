extends Area
class_name Carriable

var model: MeshInstance
var body: KinematicBody
var carrier: KinematicBody
var drop_pos: Vector3
var drop_time = 0.0
var is_carriable = false
var time = 0.0

func _ready():
	body = get_parent() as KinematicBody
	if body == null:
		print("Carriable needs kinematic parent")
	else:
		connect("body_entered", self, "on_body_entered")
		connect("body_exited", self, "on_body_exited")
		is_carriable = true
		body.set_meta("carriable", self)
	model = find_node("Model")


func carry(new_carrier: KinematicBody):
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
		body.move_and_slide(dif * 30.0, Vector3.UP)
	elif drop_pos != Vector3.ZERO:
		drop_time += delta
		var dif = drop_pos - body.global_transform.origin
		if dif.length_squared() < 0.1 or drop_time > 0.5:
			drop_pos = Vector3.ZERO
			body.move_and_collide(dif)
		body.move_and_slide(dif * 20.0, Vector3.UP)
	elif not body.is_on_floor():
		body.move_and_slide(Vector3.DOWN * 5.0)
	else:
		set_physics_process(false)
	

func on_body_entered(body: Node) -> void:
	if not is_carriable:
		return
	if not body is KinematicBody:
		return
	if not body.has_method("set_carriable"):
		return
	body.call_deferred("set_carriable", self)
	
	
func on_body_exited(body: Node) -> void:
	if not is_carriable:
		return
	if not body is KinematicBody:
		return
	if not body.has_method("unset_carriable"):
		return
	body.call_deferred("unset_carriable", self)
