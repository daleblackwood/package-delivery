extends StaticBody
class_name Lift


var area: Area
var bodies = []
var doorL: Spatial
var doorR: Spatial
var doorCollider: CollisionShape


func _ready() -> void:
	area = find_node("Area")
	area.connect("body_entered", self, "on_body_enter")
	area.connect("body_exited", self, "on_body_exit")
	doorL = find_node("LiftDoorL")
	doorR = find_node("LiftDoorR")
	doorCollider = find_node("DoorCollider")
	set_open(false)
	
	
func set_open(value: bool) -> void:
	doorL.visible = not value
	doorR.visible = not value
	doorCollider.disabled = value


func on_body_enter(body: Node) -> void:
	if body is KinematicBody == false:
		return
	if bodies.has(body):
		return
	if body.has_method("lift_enter"):
		body.call_deferred("lift_enter", self)
	bodies.append(body)
	
	
func on_body_exit(body: Node) -> void:
	if body is KinematicBody == false:
		return
	var index = bodies.find(body)
	if index < 0:
		return
	if body.has_method("lift_exit"):
		body.call_deferred("lift_exit", self)
	bodies.remove(index)
	
