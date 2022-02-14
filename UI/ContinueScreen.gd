extends Node

export(PackedScene) var next_scene

var space_pressed = true


func _process(delta):
	var was_space_pressed = space_pressed
	space_pressed = Inputs.is_any_use()
	if space_pressed and not was_space_pressed:
		var scene_instance = next_scene.instance()
		get_tree().change_scene(next_scene.resource_path)
