extends Camera

export var target_path: NodePath
export var distance = 20.0
export var height_multi = 1.3

func _process(delta):
	var target = get_node(target_path)
	if target == null:
		return
		
	var target_pos = target.global_transform.origin
	var cam_pos = target_pos
	cam_pos.z += distance
	cam_pos.y += distance * height_multi
	global_transform.origin = cam_pos
	
	look_at(target_pos, Vector3.UP)
