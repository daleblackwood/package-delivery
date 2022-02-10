extends Control
class_name UIMessage

var label_title: Label
var label_subtitle: Label
var time_left = 0.0


func _ready():
	label_title = find_node("Title")
	label_subtitle = find_node("Subtitle")
	hide()
	
	
func _process(delta):
	if not visible:
		return
	time_left -= delta
	if time_left <= 0.0:
		hide()


func display(title: String, subtitle: String, time: float = 3.0) -> void:
	visible = true;
	set_label(label_title, title)
	set_label(label_subtitle, subtitle)
	time_left = time
	
	
func hide() -> void:
	visible = false
	
	
func set_label(label: Label, text: String) -> void:
	label.visible = text != null and text.length() > 0
	label.text = "" if text == null else text
