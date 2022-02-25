extends Button

export(String) var link

func _ready() -> void:
	connect("pressed", self, "_on_pressed")
	
	
func _on_pressed() -> void:
	OS.shell_open(link)
