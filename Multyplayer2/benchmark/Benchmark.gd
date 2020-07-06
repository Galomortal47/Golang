extends Node



func _ready():
	for i in range(0,60):
		var new_instance = load("res://benchmark/Multiplayer.tscn").instance()
		new_instance.index = i
		add_child(new_instance)
	print(get_child_count())
