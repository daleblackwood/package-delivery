extends Node

var message: UIMessage
var loader: Control

func _ready():
	message = find_node("Message")
	loader = find_node("Loader")
	loader.visible = false
	
	
func show_loader(on: bool, title: String = "") -> void:
	loader.visible = on
	loader.get_child(0).get_child(0).get_child(0).text = title
