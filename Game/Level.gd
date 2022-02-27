extends Spatial
class_name Level

export(Array, PackedScene) var prefabs = []

var players = []
var packages = []
var lift: Lift
var main_light: DirectionalLight
var main_light_color: Color

enum LevelState { PreInit, Init, Ready, Playing, LiftOpen, Complete, Failed, Exited }
var state = LevelState.PreInit
var packages_left = 0
var is_built = false
var state_time = 0.0
var finish_player_index = -1


func _ready() -> void:
	Game.level = self
	lift = find_node("Lift")
	main_light = find_node("MainLight")
	main_light_color = main_light.light_color
	
	
func reset() -> void:
	players = []
	packages = []
	var origin = lift.global_transform.origin + lift.global_transform.basis.z * 1.0
	for i in range(Game.player_count):
		var prefab_i = i % Game.player_count
		var player = Game.player_prefabs[prefab_i].instance()
		add_child(player)
		player.global_transform.origin = origin + Vector3.RIGHT * (i * 2.0 / Game.player_count * 2.0 - Game.player_count)
		register_player(player)
	set_state(LevelState.Ready)


func register_player(player) -> void:
	if players.has(player):
		return
	player.register_player(players.size(), self)
	player.set_enabled(false)
	players.append(player)
	
	
func on_spawned(node: Spatial) -> void:
	if node.name.begins_with("Package"):
		packages.append(node)
		
		
func on_map_built() -> void:
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
				finish_player_index = player.player_index
				Game.score_inc(finish_player_index, 1)
		if live_player_count == 0:
			set_state(LevelState.Failed)
		if finished_player_count > 0:
			set_state(LevelState.Complete)
	if state >= LevelState.Complete and state_time > 3.0:
		var prev_state = state
		state = LevelState.Exited
		set_process(false)
		if prev_state == LevelState.Complete:
			Game.load_next_level()
		else:
			Game.reload_scene()
		
			
			
func set_state(new_state: int) -> void:
	if new_state == state:
		return
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
		var msg = "You have great package!"
		if Game.player_count > 1:
			msg = "Player %d gets the promotion!" % (finish_player_index + 1)
		GameUI.message.display("Stage Complete!", msg)
		light_color = Color.white
	elif state >= LevelState.LiftOpen:
		GameUI.message.display("Lift Open!", "Get outta here!")
		light_color = Color.white
	main_light.light_color = light_color
	var enable_players = state >= LevelState.Playing and state <= LevelState.Complete
	for player in players:
		player.set_enabled(enable_players)
		
		
func instance(prefab_name: String, position: Vector3) -> Spatial:
	var prefab = Game.get_prefab(prefab_name)
	if prefab == null:
		printerr("Can't instance %s" % prefab_name)
		return null
	var instance = prefab.instance() as Spatial
	add_child(instance)
	instance.transform.origin = position
	return instance
