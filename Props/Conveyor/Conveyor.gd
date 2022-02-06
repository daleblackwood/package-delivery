extends Spatial

var model: MeshInstance
var area: Area
var mat: SpatialMaterial
var time = 0.0
var bodies = []


func _ready() -> void:
	model = find_node("Model")
	area = find_node("Area")
	area.connect("body_entered", self, "on_body_enter")
	area.connect("body_exited", self, "on_body_exit")
	
	
func _physics_process(delta):
	time += delta	
	var mat = model.get_active_material(0)
	mat.uv1_offset = Vector3(0.0, time * 3.0, 0.0)
	for body in bodies:
		var speed = 2.0 / body.get_meta("conveyor_count")
		body.move_and_slide(global_transform.basis.z * -speed, Vector3.UP)


func on_body_enter(body: Spatial) -> void:
	if body is KinematicBody == false:
		return
	if bodies.has(body):
		return
	body.set_meta("conveyor_count", 1 if not body.has_meta("conveyor_count") else body.get_meta("conveyor_count") + 1)
	bodies.append(body)
	
	
func on_body_exit(body: Spatial) -> void:
	if body is KinematicBody == false:
		return
	var index = bodies.find(body)
	if index < 0:
		return
	body.set_meta("conveyor_count", body.get_meta("conveyor_count") - 1)
	bodies.remove(index)
