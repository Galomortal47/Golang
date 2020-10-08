extends Multyplayer

func _ready():
	get_node("pinglist/Label2").set_text("lobby: #" + str(get_node('/root/Singleton').PORT))
	get_node("pinglist/TextEdit").set_text(str(get_node('/root/Singleton').PORT))

func _physics_process(delta):
	get_node("pinglist/Label3").set_text(str(int((string.length()) * get_node("/root/Singleton").framerate * 8 / 1000)) + " kbps o data being used")
	for key in recive_data.keys():
		for key2 in recive_data[key]:
#			if get_script().get_script_method_list().has(key2):
			callv(key2,[key,recive_data[key][key2]])
	refresh_frames += 1
	if  refresh_frames > 5:
		json["time"] = str(OS.get_system_time_msecs())
#		json["password"] = get_node("/root/Singleton").password
		refresh_frames = 0

#commands
func id(var key_id,var arg):
	pass

func pwd(var key_id,var arg):
	pass


var pinglist = {}
var norepeat = {}
func time(var key_id,var arg):
#	print(key_id)
	data = recive_data.duplicate()
	for i in data.keys():
		if data.has(i):
			if data[str(i)].has("time"):
				var ping = int(data[str(i)]["time"])
				if norepeat.has(str(i)):
					if norepeat[str(i)] == ping:
						return
				var time = OS.get_system_time_msecs() - ping - (1000  / get_node("/root/Singleton").framerate * 2)
				pinglist[str(i)] = time
				norepeat[str(i)] = ping
		if not pinglist.has(i):
			pinglist[str(i)] = "loading"
	for i in pinglist.keys():
		if not data.has(i):
			pinglist.erase(i)
	var gigatext = ""
	for i in pinglist.keys():
		gigatext += str(i) + " : ping : " + str(pinglist[i]) + "\n"
	get_node("pinglist/RichTextLabel").set_text(gigatext)
	get_node("pinglist/Label").set_text("total players:" + str(data.keys().size()))
#	pinglist = {}

func _on_Button_button_down():
	get_node("/root/Singleton").PORT = int(get_node("pinglist/TextEdit").get_text())
	get_tree().reload_current_scene()
#	get_node("/root/Singleton").Ip = get_node("pinglist/TextEdit2").get_text()
	print(int(get_node("pinglist/TextEdit").get_text()))
	packet.disconnect_from_host()
	pass # Replace with function body.

func _on_backtobrowse_button_down():
	get_node("/root/Singleton").PORT = 8200
	get_tree().change_scene("res://ServerBrowse.tscn")
	pass # Replace with function body.
