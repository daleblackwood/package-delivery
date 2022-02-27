extends Node

export(int, 0, 4) var player_count = 2
export(Array, PackedScene) var player_prefabs
export(Array, PackedScene) var prefabs
export(Array, PackedScene) var levels
export(PackedScene) var scene_scores
export(PackedScene) var scene_menu
export(PackedScene) var scene_settings


var level
var current_scene: String = ""
var history = []
var time = 0.0
var state_func = ""
var state_time = 0.0
var scores = []


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
	var scene_title = scene_path_to_title(current_scene)
	GameUI.show_loader(true)
	set_state("_load_scene_switch")
	
	
func load_scene(scene_or_path, scene_title: String = "") -> void:
	if state_func.begins_with("_load_scene_switch"):
		print("Scene already loading")
		return
	if scene_or_path == null:
		printerr("Can not load null scene or path")
		return
	var scene_path = parse_scene_path(scene_or_path)
	current_scene = scene_path
	if scene_or_path is int and scene_or_path == SceneTypes.SceneType.Back:
		if history.size() > 2:
			history.resize(history.size() - 2)
		else:
			history.resize(0)
	else:
		history.append(current_scene)
	if scene_title.length() < 1:
		scene_title = scene_path_to_title(scene_path)
	GameUI.show_loader(true, scene_title)
	set_state("_load_scene_switch")
	

	
func _load_scene_switch() -> void:
	get_tree().change_scene(current_scene)
	set_state("_load_scene_wait")
	
	
func _load_scene_wait() -> void:
	if state_time > 2.0:
		GameUI.show_loader(false)
		set_state("")
	
	
func load_next_level() -> void:
	var next_scene = get_next_level()
	if next_scene == null:
		next_scene = scene_scores
	load_scene(next_scene)
	
	
func get_next_level() -> PackedScene:
	var current_index = get_level_index(current_scene)
	var next_index = current_index + 1
	if next_index >= levels.size():
		return null
	var next_level = levels[next_index]
	return next_level
		
		
func get_level_index(name: String) -> int:
	var key = parse_resource_key(name)
	for i in range(levels.size()):
		if parse_resource_key(levels[i]) == key:
			return i
	return -1
	
	
func score_reset() -> void:
	scores = []
	
	
func score_set(player_index: int, score: int) -> void:
	if player_index >= scores.size():
		scores.resize(player_index + 1)
	scores[player_index] = score
	
	
func score_inc(player_index: int, inc: int) -> void:
	var new_score = score_get(player_index) + inc
	score_set(player_index, new_score)
	
	
func score_get(player_index: int) -> int:
	if player_index >= scores.size():
		return 0
	var result = scores[player_index]
	if result == null:
		result = 0
	return result
	
	
func get_leaders() -> Array:
	var highest_score = 0
	for i in range(player_count):
		var score = score_get(i)
		if score >= highest_score:
			highest_score = score
	var result = []
	for i in range(player_count):	
		var score = score_get(i)
		if score == highest_score:
			result.append(i)
	return result
	
	
func get_score_string() -> String:
	var result = ""
	for i in range(player_count):
		result += "P%d: $%d" % [i + 1, score_get(i)]
		if i < player_count - 1:
			result += "   "
	return result
	
	
func scene_path_to_title(scene_or_path) -> String:
	var result = parse_resource_name(scene_or_path)
	if result.begins_with("Screen"):
		result = result.substr(6)
	if result.begins_with("Level_"):
		result = result.substr(6)
	return result
	
	
func set_state(func_name: String) -> void:
	state_func = func_name
	state_time = 0.0

		
func get_prefab(name: String) -> PackedScene:
	var key = parse_resource_key(name)
	for prefab in prefabs:
		if parse_resource_key(prefab.resource_path) == key:
			return prefab
	return null
	
	
func parse_scene_path(name_path_or_resource) -> String:
	if name_path_or_resource is int:
		match name_path_or_resource:
			SceneTypes.SceneType.Menu:
				return parse_resource_path(scene_menu)
			SceneTypes.SceneType.Next_Level:
				return parse_resource_path(get_next_level())
			SceneTypes.SceneType.Back:
				if history.size() > 2:
					return history[history.size() - 2]
				return parse_resource_path(scene_menu)
			SceneTypes.SceneType.Score:
				return parse_resource_path(scene_scores)
			SceneTypes.SceneType.Settings:
				return parse_resource_path(scene_settings)
		printerr("Unknown scene value %d" % name_path_or_resource)
		return parse_resource_path(scene_menu)
	return parse_resource_path(name_path_or_resource)

	
func parse_resource_path(name_path_or_resource) -> String:
	if name_path_or_resource is PackedScene or name_path_or_resource is Resource:
		return name_path_or_resource.resource_path
	return name_path_or_resource as String
	

func parse_resource_name(name_path_or_resource) -> String:
	var result = parse_resource_path(name_path_or_resource)
	if result == null or result.length() < 1:
		return ""
	var last_slash = result.find_last("/")
	if last_slash >= 0:
		result = result.substr(last_slash + 1)
	var last_dot = result.find_last(".")
	if last_dot >= 0:
		result = result.substr(0, last_dot)
	result = result.replace("_", " ")
	return result
	
	
func parse_resource_key(name_path_or_resource) -> String:
	var name = parse_resource_name(name_path_or_resource).to_upper()
	var result = ""
	for i in range(name.length()):
		var c = name[i]
		if c >= 'A' and c <= 'Z':
			result += c
		elif c >= '0' and c <= '9':
			result += c
	return result
	
