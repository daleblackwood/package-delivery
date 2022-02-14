extends Node

export(PackedScene) var next_scene

var space_pressed = true

var button_1p: Button
var button_2p: Button

func _ready() -> void:
	var buttons = find_node("Buttons")
	button_1p = buttons.find_node("Button1P")
	button_1p.connect("pressed", self, "start_1P")
	button_2p = buttons.find_node("Button2P")
	button_2p.connect("pressed", self, "start_2P")
	
		
func start_1P() -> void:
	Game.player_count = 1
	_start()


func start_2P() -> void:
	Game.player_count = 2
	_start()


func _start() -> void:
	var scene_instance = next_scene.instance()
	get_tree().change_scene(next_scene.resource_path)
