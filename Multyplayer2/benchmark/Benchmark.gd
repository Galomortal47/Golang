extends Node

var x = 0
var test = 80

func _ready():
	for i in range(0,test):
		var new_instance = load("res://benchmark/Multiplayer.tscn").instance()
		new_instance.index = i
		add_child(new_instance)
		x += 1
		if x >= test / 5:
			print(get_node("/root/Singleton").PORT)
			get_node("/root/Singleton").PORT += 1
			x = 0
			
	print(get_child_count())
