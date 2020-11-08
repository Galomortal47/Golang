extends Node

var x = 7
var test = 150
var multi = load("res://benchmark/Multiplayer.tscn")
var refresh_frames = 0

func _ready():
	get_node("/root/Singleton").PORT = 3560
	spawn()
#	get_node("/root/Singleton").PORT = 8083
#	spawn()
#	get_node("/root/Singleton").PORT = 8084
#	spawn()
#	get_node("/root/Singleton").PORT = 8085
#	spawn()
#	get_node("/root/Singleton").PORT = 8086
#	spawn()
#	get_node("/root/Singleton").PORT = 8087
#	spawn()
#	get_node("/root/Singleton").PORT = 8088
#	spawn()
#	get_node("/root/Singleton").PORT = 8089
#	spawn()
#	get_node("/root/Singleton").PORT = 8090
#	spawn()
#	get_node("/root/Singleton").PORT = 8091
#	spawn()
	print(get_child_count())

func spawn():
	for i in range(0,test):
		var new_instance = multi.instance()
		new_instance.id = str(x)
		add_child(new_instance)
		x += 1
