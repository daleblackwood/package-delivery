extends Control


export(float) var distance = 5.0

var init_pos: Vector2

func _ready():
	init_pos = rect_position


func _process(delta):
	var pos = init_pos
	pos.y += sin(Game.time * 3.0) * distance
	rect_position = pos
