extends GridMap
class_name SpawnGridMap

export(PackedScene) var map_scene

var references = []


func _ready() -> void:
	clear()
	call_deferred("build")
	
	
func clear() -> void:
	for child in get_children():
		remove_child(child)
	
	
func build() -> void:
	references = []
	var map_inst = map_scene.instance()
	var item_ids = mesh_library.get_item_list()
	var highest_id = 0
	for item_id in item_ids:
		if item_id > highest_id:
			highest_id = item_id
	references.resize(highest_id + 1)
	for item_id in item_ids:
		var item_name = mesh_library.get_item_name(item_id)
		var item = map_inst.find_node(item_name) as SpawnGridMapSpawner
		if item != null:
			var script = item.get_script() as Script
			if script != null:
				var item_ref = SpawnGridMapSpawner.new()
				item_ref.name = item.name
				for prop in item.get_property_list():
					if (prop.usage & PROPERTY_USAGE_SCRIPT_VARIABLE) != 0 and (prop.usage & PROPERTY_USAGE_DEFAULT) != 0:
						item_ref[prop.name] = item[prop.name]
				references[item_id] = item_ref
	var cells = get_used_cells()
	for cell in cells:
		var item_id = get_cell_item(cell.x, cell.y, cell.z)
		if item_id >= references.size():
			continue
		var item_ref = references[item_id]
		if item_ref == null:
			continue
		var orientation = get_cell_item_orientation(cell.x, cell.y, cell.z)
		var basis = orthoganal_to_basis(orientation)
		var item_inst = item_ref.duplicate()
		item_inst.name = "%s_%d_%d_%d" % [item_ref.name, cell.x, cell.y, cell.z]
		set_cell_item(cell.x, cell.y, cell.z, INVALID_CELL_ITEM)
		call_deferred("add_item", item_inst, cell, basis)
	var parent = self
	while parent != null:
		if parent.has_method("on_map_built"):
			parent.call("on_map_built")
		parent = parent.get_parent()
		
		
func add_item(item_inst: Spatial, cell: Vector3, basis: Basis) -> void:
	var pos = cell * cell_size
	if cell_center_x:
		pos.x += cell_size.x * 0.5
	if cell_center_y:
		pos.y += cell_size.y * 0.5
	if cell_center_z:
		pos.z += cell_size.z * 0.5
	item_inst.transform.origin = pos
	if item_inst.has_method("set_map"):
		item_inst.set_map(self, cell, basis)
	add_child(item_inst)
	
const orthogonal_angles = [
	Vector3(0, 0, 0),
	Vector3(0, 0, PI/2),
	Vector3(0, 0, PI),
	Vector3(0, 0, -PI/2),
	Vector3(PI/2, 0, 0),
	Vector3(PI, -PI/2, -PI/2),
	Vector3(-PI/2, PI, 0),
	Vector3(0, -PI/2, -PI/2),
	Vector3(-PI, 0, 0),
	Vector3(PI, 0, -PI/2),
	Vector3(0, PI, 0),
	Vector3(0, PI, -PI/2),
	Vector3(-PI/2, 0, 0),
	Vector3(0, -PI/2, PI/2),
	Vector3(PI/2, 0, PI),
	Vector3(0, PI/2, -PI/2),
	Vector3(0, PI/2, 0),
	Vector3(-PI/2, PI/2, 0),
	Vector3(PI, PI/2, 0),
	Vector3(PI/2, PI/2, 0),
	Vector3(PI, -PI/2, 0),
	Vector3(-PI/2, -PI/2, 0),
	Vector3(0, -PI/2, 0),
	Vector3(PI/2, -PI/2, 0)
]
	
func orthoganal_to_basis(index: int) -> Basis:
	if index < 0 || index >= orthogonal_angles.size():
		printerr("Invalid basis index: %d" % index)
		return Basis()
	var rot = Quat()
	rot.set_euler(orthogonal_angles[index])
	return Basis(rot)
	
