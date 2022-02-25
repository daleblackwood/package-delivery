extends Node
class_name InputGroup


var buttons = []
var is_axis_down = false
var selected: Button = null

func _ready():
	buttons = collect_buttons(self)
			
			
func collect_buttons(parent: Node, list: Array = []) -> Array:
	for i in range(parent.get_child_count()):
		var child = parent.get_child(i)
		if child is Button:
			list.append(child)
		elif child.get_child_count() > 0:
			collect_buttons(child, list)
	return list
	
	
func get_button(name: String) -> Button:
	for button in buttons:
		if button.name == name:
			return button
	return null
		
		
func select(button: Button):
	selected = button
	selected.grab_focus()
			
			
func _process(delta):
	if buttons.size() < 1:
		return
	if selected == null:
		select(buttons[0])
	var selected_pos = selected.rect_global_position
	var was_axis_down = is_axis_down
	var axis = Inputs.get_all_axes()
	is_axis_down = axis.length_squared() > 0.6
	if is_axis_down and not was_axis_down:
		var closest = null
		var closest_sq = INF
		for button in buttons:
			if button == selected:
				continue
			var pos = (button as Button).rect_global_position
			var dif = pos - selected_pos
			if axis.dot(dif) < 0:
				continue
			var sq = dif.length_squared()
			if sq < closest_sq:
				closest_sq = sq
				closest = button
		if closest != null:
			select(closest)
	if selected != null and Inputs.is_any_use():
		selected.emit_signal("pressed")
		
