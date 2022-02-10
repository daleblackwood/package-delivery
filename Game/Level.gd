extends Spatial
class_name Level

export(Array, PackedScene) var prefabs = []
export(PackedScene) var next_level

var players = []
var packages = []
var lift: Lift
var main_light: DirectionalLight
var main_light_color: Color

enum LevelState { PreInit, Init, Ready, Playing, LiftOpen, Complete, Failed }
var state = LevelState.PreInit
var packages_left = 0
var is_built = false
var state_time = 0.0


func _ready() -> void:
	Game.level = self
	lift = find_node("Lift")
	main_light = find_node("MainLight")
	main_light_color = main_light.light_color
	
	
func reset() -> void:
	players = []
	packages = []
	for i in range(get_child_count()):
		var child = get_child(i)
		if child.has_method("register_player"):
			register_player(child)
	set_state(LevelState.Ready)


func register_player(player) -> void:
	if players.has(player):
		return
	player.register_player(players.size(), self)
	players.append(player)
	
	
func on_spawned(node: Spatial) -> void:
	if node.name.begins_with("Package"):
		print("got package " + node.name)
		packages.append(node)
		
		
func on_map_built() -> void:
	print("build completed")
	is_built = true
	call_deferred("reset")


func _process(delta: float) -> void:
	state_time += delta
	if state >= LevelState.Playing and state < LevelState.LiftOpen:
		var active_packages = 0
		for package in packages:
			if package == null:
				return
			if package.visible:
				active_packages += 1
		if active_packages != packages_left:
			packages_left = active_packages
			if packages_left == 0:
				set_state(LevelState.LiftOpen)
	if state >= LevelState.Playing and state < LevelState.Complete:
		var live_player_count = 0
		var finished_player_count = 0
		for player in players:
			if player.state != Player.PlayerState.Dead:
				live_player_count += 1
			if player.state == Player.PlayerState.Finished:
				finished_player_count += 1
		if live_player_count == 0:
			set_state(LevelState.Failed)
		if finished_player_count == players.size():
			set_state(LevelState.Complete)
	if state >= LevelState.Complete and state_time > 3.0:
		if state == LevelState.Complete:
			if next_level != null:
				get_tree().change_scene(next_level.resource_path)
			else:
				get_tree().change_scene("res://UI/WinScreen.tscn")
			return
		get_tree().change_scene("res://UI/TitleScreen.tscn")
		
			
			
func set_state(new_state: int) -> void:
	if new_state == state:
		return
	print("state: %d" % new_state)
	state = new_state
	state_time = 0.0
	if lift != null:
		lift.set_open(new_state == LevelState.LiftOpen)
	if state == LevelState.Ready:
		GameUI.message.display("Go!", "Get packing!")
		state = LevelState.Playing
	var light_color = main_light_color
	if state == LevelState.Failed:
		light_color = Color.yellow
		GameUI.message.display("Failed!", "You peed yourself.")
	elif state == LevelState.Complete:
		GameUI.message.display("Stage Complete!", "You have great package!")
		light_color = Color.white
	elif state >= LevelState.LiftOpen:
		GameUI.message.display("Lift Open!", "Get outta here!")
		light_color = Color.white
	main_light.light_color = light_color
	var enable_players = state >= LevelState.Playing and state <= LevelState.Complete
	for player in players:
		player.set_enabled(enable_players)
		
		
func instance(name: String, position: Vector3) -> Spatial:
	var prefab = get_prefab(name)
	var instance = prefab.instance() as Spatial
	add_child(instance)
	instance.transform.origin = position
	return instance
	
		
func get_prefab(name: String) -> PackedScene:
	name = name.to_lower()
	for prefab in prefabs:
		var path = prefab.resource_path as String
		if path == null or path.length() < 1:
			continue
		if path.to_lower().ends_with("/" + name + ".tscn"):
			return prefab
	return null
