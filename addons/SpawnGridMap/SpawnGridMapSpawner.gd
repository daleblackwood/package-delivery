extends Spatial
class_name SpawnGridMapSpawner

export(Array, PackedScene) var scenes = [null]
export(bool) var use_respawn = false
export(float, 0.0, 10.0) var respawn_time = 5.0
export(float) var respawn_distance = 5.0
export(bool) var spawn_random = false
export(int) var random_seed = 0
export(Array, int) var scene_weights = [1]
export(bool) var use_map_orientation = true
export(bool) var use_map_scale = false

var time_to_spawn = 0.0
var last_spawn: Spatial = null
var next_spawn: PackedScene = null
var next_spawn_index = 0
var rng: RandomNumberGenerator = null
var map: GridMap = null
var cell = Vector3()
var basis = Basis()


func set_map(_map: GridMap, _cell: Vector3, _basis: Basis) -> void:
	map = _map
	cell = _cell
	basis = _basis
	

func _enter_tree() -> void:
	reset()
	call_deferred("spawn")
	

func reset() -> void:
	rng = null
	next_spawn_index = 0
	set_process(use_respawn)
	
	
func _process(delta: float) -> void:
	if use_respawn == false:
		return
	if last_spawn != null and respawn_distance > 0.0:
		var dif = last_spawn.global_transform.origin - global_transform.origin
		if dif.length_squared() < respawn_distance * respawn_distance:
			time_to_spawn = respawn_time
	time_to_spawn -= delta
	if time_to_spawn <= 0.0:
		spawn()


func spawn() -> void:
	if next_spawn == null:
		pick_next_spawn()
	if next_spawn == null:
		printerr(name + " can't spawn null scene")
		return
	last_spawn = next_spawn.instance() as Spatial
	last_spawn.transform.origin = transform.origin
	if map != null:
		var spawn_basis = Basis()
		if use_map_orientation:
			spawn_basis = basis
		if use_map_scale:
			spawn_basis = spawn_basis.scaled(Vector3.ONE * map.cell_size)
		last_spawn.transform.basis = spawn_basis
	get_parent().call_deferred("add_child", last_spawn)
	var parent = self
	while parent != null:
		if parent.has_method("on_spawned"):
			parent.call("on_spawned", last_spawn)
		parent = parent.get_parent()
	time_to_spawn = respawn_time
	next_spawn = null
	
	
func pick_next_spawn() -> PackedScene:
	next_spawn = null
	var scene_count = scenes.size()
	if scene_count < 1:
		printerr(name + " has nothing to spawn!")
		return null
	if spawn_random and scene_count > 1:
		if rng == null:
			rng = RandomNumberGenerator.new()
			rng.seed = random_seed
		var weight_count = scene_weights.size()
		var total_weight = 0.0
		for i in range(scene_count):
			var weight = 1
			if i < weight_count:
				weight = scene_weights[i]
			total_weight += weight
		var selected_weight = rng.randf() * total_weight
		total_weight = 0.0
		for i in range(scene_count):
			var weight = 1
			if i < weight_count:
				weight = scene_weights[i]
			total_weight += weight
			if total_weight >= selected_weight:
				next_spawn = scenes[i]
				break
	else:
		next_spawn = scenes[next_spawn_index & scene_count]
		next_spawn_index += 1
		if next_spawn_index >= scene_count:
			next_spawn_index = 0
	return next_spawn
