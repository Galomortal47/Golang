extends Multyplayer

func _physics_process(delta):
	ping()
	refresh_frames += 1
	if  refresh_frames > 60:
		pinglist()
		refresh_frames = 0

func ping():
	json["time"] = str(OS.get_system_time_msecs())

func pinglist():
	var pinglist = {}
	data = recive_data.duplicate()
	for i in data.keys():
		if data.has(i):
			if data[str(i)]["Object"].has("time"):
				var time = OS.get_system_time_msecs() - int(data[str(i)]["Object"]["time"]) - 33
				pinglist[str(i)] = time
	var gigatext = ""
	for i in pinglist.keys():
		gigatext += str(i) + " : ping : " + str(pinglist[i]) + "\n"
	get_node("pinglist/RichTextLabel").set_text(gigatext)
	get_node("pinglist/Label").set_text("total players:" + str(pinglist.keys().size()))
	pinglist = {}

func _on_Button_button_down():
	get_node("/root/Singleton").PORT = int(get_node("pinglist/TextEdit").get_text())
	get_node("/root/Singleton").Ip = get_node("pinglist/TextEdit2").get_text()
	print(int(get_node("pinglist/TextEdit").get_text()))
	packet.disconnect_from_host()
	pass # Replace with function body.
