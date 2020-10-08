extends Node

var x = 1
var test = 5
var multi = load("res://benchmark/Multiplayer.tscn")
var refresh_frames = 0

func _physics_process(delta):
	refresh_frames += 1
	if  refresh_frames > 5:
		for i in get_children():
			i.json["time"] = str(OS.get_system_time_msecs())
#		json["password"] = get_node("/root/Singleton").password
		refresh_frames = 0

func _ready():
	for i in range(0,5):
		get_node("/root/Singleton").PORT = 8084
		spawn()
	print(get_child_count())

func spawn():
	for i in range(0,test):
		var new_instance = multi.instance()
		new_instance.id = str(x)
		add_child(new_instance)
		x += 1
