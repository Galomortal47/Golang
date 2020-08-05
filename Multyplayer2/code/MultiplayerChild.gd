extends Multyplayer

func _ready():
	get_node("pinglist/Label2").set_text("lobby: #" + str(get_node('/root/Singleton').PORT))
	get_node("pinglist/TextEdit").set_text(str(get_node('/root/Singleton').PORT))

func _physics_process(delta):
	ping()
	refresh_frames += 1
	if  refresh_frames > 30:
		pinglist()
		refresh_frames = 0

func ping():
	json["time"] = str(OS.get_system_time_msecs())

func pinglist():
	get_node("pinglist/Label3").set_text(str(int(string.length() * 60 * 8 / 1000)) + " kbps o data being used")
	var pinglist = {}
	data = recive_data.duplicate()
	for i in data.keys():
		if data.has(i):
			if data[str(i)].has("time"):
				var time = OS.get_system_time_msecs() - int(data[str(i)]["time"])
				pinglist[str(i)] = time
	var gigatext = ""
	for i in pinglist.keys():
		gigatext += str(i) + " : ping : " + str(pinglist[i]) + "\n"
	get_node("pinglist/RichTextLabel").set_text(gigatext)
	get_node("pinglist/Label").set_text("total players:" + str(pinglist.keys().size()))
	pinglist = {}

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
