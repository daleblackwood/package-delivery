extends Node

export(PackedScene) var next_scene

var space_pressed = true

func _ready() -> void:
	var buttons = find_node("Buttons")
	connect_button(buttons, "Button1P", "start_1P")
	connect_button(buttons, "Button2P", "start_2P")
	connect_button(buttons, "ButtonQuit", "quit")
	
	
func connect_button(group: InputGroup, button_name: String, func_name: String) -> void:
	var button = group.get_button(button_name)
	if button == null:
		printerr("Can't find button '%s'" % button_name)
		return
	button.connect("pressed", self, func_name)
	
		
func start_1P() -> void:
	Game.player_count = 1
	_start()


func start_2P() -> void:
	Game.player_count = 2
	_start()


func _start() -> void:
	Game.load_scene(next_scene.resource_path)
	

func quit() -> void:
	OS.window_fullscreen = false
	get_tree().quit(0)
