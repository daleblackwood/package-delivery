extends Area

func _ready():
	connect("body_entered", self, "on_body_entered")
	
	
func on_body_entered(body: Node) -> void:
	if not body is KinematicBody:
		return
	var carriable = body.get_meta("carriable")
	if carriable == null or not carriable.is_carriable:
		return
	var kb = body as KinematicBody
	kb.visible = false
	kb.pause_mode = Node.PAUSE_MODE_STOP
	kb.collision_layer = 0
	kb.collision_mask = 0
