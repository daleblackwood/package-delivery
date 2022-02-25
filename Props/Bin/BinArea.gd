extends Area


var carriables = []

func _ready():
	connect("body_entered", self, "on_body_entered")
	
	
func _process(delta):
	if carriables.size() > 0:
		var target_pos = global_transform.origin + Vector3.UP
		for i in range(carriables.size() - 1, -1, -1):
			var kb = carriables[i] as KinematicBody
			var diff = target_pos - kb.global_transform.origin
			if diff.length_squared() < 0.5:
				kb.visible = false
				carriables.remove(i)
			else:
				kb.transform.origin += diff * 0.4
	else:
		set_process(false)
	
	
func on_body_entered(body: Node) -> void:
	if not body is KinematicBody:
		return
	if not body.has_meta("carriable"):
		return
	var carriable = body.get_meta("carriable")
	if carriable == null or not carriable.is_carriable:
		return
	var kb = body as KinematicBody
	kb.pause_mode = Node.PAUSE_MODE_STOP
	kb.collision_layer = 0
	kb.collision_mask = 0
	carriables.append(kb)
	set_process(true)
