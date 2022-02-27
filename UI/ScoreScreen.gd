extends ContinueScreen


var label_title: Label
var label_comment: Label


func _ready():
	._ready()
	label_title = find_node("LabelTitle")
	label_comment = find_node("LabelComment")
	var title_str = "You Win!"
	var comment_str = "You are the ultimate SPACEBEZOS."
	if Game.player_count > 1:
		var leaders = Game.get_leaders()
		title_str = ""
		for i in range(leaders.size()):
			var index = leaders[i]
			title_str += "Player %d" % (index + 1)
			if i < leaders.size() - 1:
				title_str += " and "
		title_str += " Victorious!"
		comment_str = Game.get_score_string()
	label_title.text = title_str
	label_comment.text = comment_str
