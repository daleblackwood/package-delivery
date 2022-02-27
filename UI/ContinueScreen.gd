extends Control
class_name ContinueScreen

export(SceneTypes.SceneType) var next_scene = 0
export(bool) var allow_press = true
export(float, 0.0, 10.0) var duration = 0.0

var is_pressed = true
var time_left = 0.0

func _ready():
	time_left = duration

func _process(delta):
	if allow_press:
		var was_pressed = is_pressed
		is_pressed = Inputs.is_any_use()
		if is_pressed and not was_pressed:
			load_scene()
	if duration > 0.0:
		time_left -= delta
		if time_left <= 0.0:
			load_scene()
			

func load_scene():
	set_process(false)
	Game.load_scene(next_scene)
			
