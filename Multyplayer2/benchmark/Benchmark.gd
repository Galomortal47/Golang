extends Node

var x = 1
var test = 64
var multi = load("res://benchmark/Multiplayer.tscn")
var refresh_frames = 0

func _ready():
	get_node("/root/Singleton").PORT = 8082
	spawn()
	get_node("/root/Singleton").PORT = 8083
	spawn()
	get_node("/root/Singleton").PORT = 8084
	spawn()
	get_node("/root/Singleton").PORT = 8085
	spawn()
	get_node("/root/Singleton").PORT = 8086
	spawn()
	print(get_child_count())

func spawn():
	for i in range(0,test):
		var new_instance = multi.instance()
		new_instance.id = str(x)
		add_child(new_instance)
		x += 1
