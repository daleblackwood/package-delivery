extends Button

@export var link: String

func _ready() -> void:
	connect("pressed", Callable(self, "_on_pressed"))
	
	
func _on_pressed() -> void:
	OS.shell_open(link)
