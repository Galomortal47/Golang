extends Multyplayer

func _physics_process(delta):
	var spliter = string.split("},")
	spliter = Array(spliter)
	var string = []
	for i in spliter:
		var piece = i + "}"
		var json = parse_json(piece)
		string.append(str(json))
		string.append("\n")
		string.append("\n")
	get_node("pinglist/RichTextLabel").set_text(str(string))
	pass
