extends Spatial

const target_radius = 1.6

var radius = 0.0

func _ready():
	radius = 0.0
	rotate_y(randf() * PI * 2.0)
	
	
func _process(delta: float) -> void:
	radius = lerp(radius, target_radius, 0.1)
	if radius > 1.5:
		radius = 1.5
	global_transform.basis = Basis().scaled(Vector3.ONE * radius)
