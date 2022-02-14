extends Node

export(PackedScene) var next_scene

var space_pressed = true
var player_count_label: Label
var player_action_label: Label


func _ready() -> void:
	player_count_label = find_node("PlayerCountLabel")
	player_action_label = find_node("PlayerActionLabel")
	update_text()
	
	
func update_text() -> void:
	player_count_label.text = "%d Player Mode" % Game.player_count
	if Game.player_count == 2:
		player_action_label.text = "Press 1 for One Player Mode"
	else:
		player_action_label.text = "Press 2 for Two Player Mode"
		


func _process(delta):
	if Input.is_key_pressed(KEY_1) and Game.player_count != 1:
		Game.player_count = 1
		update_text()
	elif Input.is_key_pressed(KEY_2) and Game.player_count != 2:
		Game.player_count = 2
		update_text()	
	
	var was_space_pressed = space_pressed
	space_pressed = Input.is_key_pressed(KEY_SPACE)
	if space_pressed and not was_space_pressed:
		var scene_instance = next_scene.instance()
		get_tree().change_scene(next_scene.resource_path)

