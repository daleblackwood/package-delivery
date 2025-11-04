extends Area3D

var drainers = []
var pissed = false
var feet: Node3D


func _ready():
	connect("body_entered", Callable(self, "on_body_enter"))
	connect("body_exited", Callable(self, "on_body_exit"))
	feet = find_child("Feet")
	
	
func _process(delta):
	for drainer in drainers:
		if not drainer.can_piss():
			continue
		pissed = true
		visible = false
		Game.level.instance("Piss", global_transform.origin)
		drainer.drain_piss()
		set_process(false)
		return
		
	
func on_body_enter(body: Node) -> void:
	if pissed:
		return
	if not body is Node3D:
		return
	if drainers.has(body):
		return
	if not body.has_method("can_piss"):
		return
	drainers.append(body)
	
	
func on_body_exit(body: Node) -> void:
	if not body is Node3D:
		return
	var index = drainers.find(body)
	if index < 0:
		return
	drainers.remove_at(index)
