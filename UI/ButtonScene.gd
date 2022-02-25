extends Button

export(String, FILE, "*.tscn,*.scn") var scene_path

func _ready() -> void:
	connect("pressed", self, "_on_pressed")
	
	
func _on_pressed() -> void:
	Game.load_scene(scene_path)
