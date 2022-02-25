extends Node

export(int, 0, 4) var player_count = 2
export(Array, PackedScene) var player_prefabs

var level: Level
var next_scene = null
var time = 0.0
var state_func = ""
var state_time = 0.0

func _ready():
	if not OS.is_debug_build():
		OS.window_fullscreen = true


func _process(delta: float) -> void:
	time += delta
	var prev_state_func = state_func
	if state_func != null and state_func.length() > 0:
		call(state_func)
		if state_func != prev_state_func:
			state_time = 0.0
		state_time += delta
	
		
func reload_scene() -> void:
	GameUI.show_loader(true)
	set_state("_load_scene_switch")
	
	
func load_scene(scene_path: String) -> void:
	next_scene = scene_path
	GameUI.show_loader(true)
	set_state("_load_scene_switch")
	
	
func _load_scene_switch() -> void:
	get_tree().change_scene(next_scene)
	set_state("_load_scene_wait")
	
	
func _load_scene_wait() -> void:
	if state_time > 2.0:
		GameUI.show_loader(false)
		set_state("")
	
	
func set_state(func_name: String) -> void:
	state_func = func_name
	state_time = 0.0
