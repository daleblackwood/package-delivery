extends Area

var drainers = []
var pissed = false
var feet: Spatial


func _ready():
	connect("body_entered", self, "on_body_enter")
	connect("body_exited", self, "on_body_exit")
	feet = find_node("Feet")
	
	
func _process(delta):
	for drainer in drainers:
		drainer.drain_piss()
		
	
func on_body_enter(body: Node) -> void:
	if pissed:
		return
	if not body is Spatial:
		return
	if drainers.has(body):
		return
	if not body.has_method("can_piss"):
		return
	if not body.can_piss():
		return
	drainers.append(body)
	pissed = true
	visible = false
	Game.level.instance("Piss", global_transform.origin)
	
	
func on_body_exit(body: Node) -> void:
	if not body is Spatial:
		return
	var index = drainers.find(body)
	if index < 0:
		return
	drainers.remove(index)
