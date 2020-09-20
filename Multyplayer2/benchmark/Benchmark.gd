extends Node

var x = 0
var test = 50
var multi = load("res://benchmark/Multiplayer.tscn")

func _ready():
	for i in range(0,5):
		get_node("/root/Singleton").PORT = 8082 + i
		spawn()
	print(get_child_count())

func spawn():
	for i in range(0,test):
		var new_instance = multi.instance()
		new_instance.json.id = str(x)
		add_child(new_instance)
		x += 1
