extends Node

export(PackedScene) var next_scene
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
			Game.load_scene(next_scene.resource_path)
	if duration > 0.0:
		time_left -= delta
		if time_left <= 0.0:
			Game.load_scene(next_scene.resource_path)
			
