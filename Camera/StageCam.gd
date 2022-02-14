extends Camera

export var distance = 20.0
export var height_multi = 1.3

func _process(delta):
	var target_pos = Vector3()
	var target_count = 0
	for player in get_parent().players:
		target_pos += player.global_transform.origin
		target_count += 1
	if target_count > 0:
		target_pos /= target_count
		
	var cam_pos = target_pos
	cam_pos.z += distance
	cam_pos.y += distance * height_multi
	global_transform.origin = cam_pos
	
	look_at(target_pos, Vector3.UP)
