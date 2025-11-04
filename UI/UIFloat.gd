extends Control


@export var distance: float = 5.0

var init_pos: Vector2

func _ready():
	init_pos = position


func _process(delta):
	var pos = init_pos
	pos.y += sin(Game.time * 3.0) * distance
	position = pos
