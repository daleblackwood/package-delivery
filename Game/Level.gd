extends Spatial
class_name Level


var players = []
var packages = []
var lift: Lift
var main_light: DirectionalLight
var main_light_color: Color

enum LevelState { PreInit, Init, Ready, Playing, LiftOpen, Complete, Failed }
var state = LevelState.PreInit
var packages_left = 0
var is_built = false


func _ready() -> void:
	lift = find_node("Lift")
	main_light = find_node("MainLight")
	main_light_color = main_light.light_color
	
	
func reset() -> void:
	players = []
	packages = []
	set_state(LevelState.Ready)


func register_player(player) -> void:
	if players.has(player):
		return
	player.player_index = players.size()
	player.level = self
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
	if state == LevelState.Playing:
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
			
			
func set_state(new_state: int) -> void:
	if new_state == state:
		return
	print("state: %d" % new_state)
	state = new_state
	if lift != null:
		lift.set_open(new_state >= LevelState.LiftOpen)
	if state == LevelState.Ready:
		state = LevelState.Playing
	var light_color = main_light_color
	if state >= LevelState.LiftOpen:
		light_color = Color.white
	elif state == LevelState.Failed:
		light_color = Color.red
	main_light.light_color = light_color
		
