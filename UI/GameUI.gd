extends Node

var message: UIMessage
var loader: Control

func _ready():
	message = find_node("Message")
	loader = find_node("Loader")
	loader.visible = false
	
	
func show_loader(on: bool) -> void:
	loader.visible = on
