extends Button

export(SceneTypes.SceneType) var scene_type

func _ready() -> void:
	connect("pressed", self, "_on_pressed")
	
	
func _on_pressed() -> void:
	Game.load_scene(scene_type)
