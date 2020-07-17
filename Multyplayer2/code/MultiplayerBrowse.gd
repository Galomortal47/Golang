extends Multyplayer

func _physics_process(delta):
	var spliter = string.split("},{")
	spliter = Array(spliter)
	var piece = spliter[0]+"}"
	var json = parse_json(piece)
	get_node("pinglist/RichTextLabel").set_text('a')
	pass
