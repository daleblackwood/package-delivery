extends StaticBody3D
class_name Lift


var area: Area3D
var bodies = []
var doorL: Node3D
var doorR: Node3D
var doorCollider: CollisionShape3D


func _ready() -> void:
	area = find_child("Area3D")
	area.connect("body_entered", Callable(self, "on_body_enter"))
	area.connect("body_exited", Callable(self, "on_body_exit"))
	doorL = find_child("LiftDoorL")
	doorR = find_child("LiftDoorR")
	doorCollider = find_child("DoorCollider")
	set_open(false)
	
	
func set_open(value: bool) -> void:
	doorL.visible = not value
	doorR.visible = not value
	doorCollider.disabled = value


func on_body_enter(body: Node) -> void:
	if body is CharacterBody3D == false:
		return
	if bodies.has(body):
		return
	if body.has_method("lift_enter"):
		body.call_deferred("lift_enter", self)
	bodies.append(body)
	
	
func on_body_exit(body: Node) -> void:
	if body is CharacterBody3D == false:
		return
	var index = bodies.find(body)
	if index < 0:
		return
	if body.has_method("lift_exit"):
		body.call_deferred("lift_exit", self)
	bodies.remove_at(index)
	
