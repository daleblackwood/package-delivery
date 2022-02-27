extends Node

export(PackedScene) var current_scene

var space_pressed = true
var controller_icons: Control
var label_connect: Control
var label_join: Control

func _ready() -> void:
	var buttons = find_node("Buttons")
	connect_button(buttons, "Button1P", "start_1P")
	connect_button(buttons, "Button2P", "start_2P")
	connect_button(buttons, "ButtonQuit", "quit")
	controller_icons = find_node("ControllerIcons")
	label_connect = find_node("LabelConnect")
	label_join = find_node("LabelJoin")
	if Inputs.joysticks.size() < 1:
		Inputs.set_discovery(true)
	
	
func _process(delta):
	for i in range(2):
		controller_icons.get_child(i).set_visible(i < Inputs.joysticks.size())
	label_connect.set_visible(Inputs.joysticks.size() < 1)
	label_join.set_visible(Inputs.joysticks.size() < 2)
	
	
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
	Game.score_reset()
	Game.load_next_level()
	Inputs.set_discovery(false)
	

func quit() -> void:
	OS.window_fullscreen = false
	get_tree().quit(0)
