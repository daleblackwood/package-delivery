extends Button

@export var scene_type: SceneTypes.SceneType

func _ready() -> void:
	connect("pressed", Callable(self, "_on_pressed"))
	
	
func _on_pressed() -> void:
	Game.load_scene(scene_type)
