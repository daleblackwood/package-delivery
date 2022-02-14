extends Node


var buttons = []
var is_axis_down = false
var selected: Button = null

func _ready():
	for i in range(get_child_count()):
		var child = get_child(i)
		if child is Button:
			buttons.append(child)
		
		
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
	if is_axis_down:
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
		
