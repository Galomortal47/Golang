extends MultyplayerMultiThread

var ping_rate = 2
var packetloss= 0

func _ready():
	get_node("pinglist/Label2").set_text("lobby: #" + str(get_node('/root/Singleton').PORT))
	get_node("pinglist/TextEdit").set_text(str(get_node('/root/Singleton').PORT))

func _physics_process(delta):
	json["data"] = get_node("chat").get_text()
#	send_ping()
	kbps_calc()
	if not recive_data == null:
		for key in recive_data.keys():
			for key2 in recive_data[key]:
				callv(key2,[key,recive_data[key][key2]])
	var gigatext = ""
	for i in pinglist.keys():
		var color = "white"
		if int(pinglist[i]) > 200:
			color = 'yellow'
		if int(pinglist[i]) > 400:
			color = 'red'
		if i == id:
			color = 'aqua'
			if int(pinglist[i]) > 1000:
#				packet[0].disconnect_from_host()
				get_node("WindowDialog").show()
			else:
				get_node("WindowDialog").hide()
		gigatext += "[color="  + color + "]" + str(i) + " : ping : " + str(pinglist[i]) + "[/color]\n"
	get_node("pinglist/RichTextLabel").set_bbcode(gigatext)

func reconect():
	if packetloss == 100:
		_on_Button_button_down()

var frame_per_sec = [0]
var interations = 0
var array_size = 600
func kbps_calc():
	if frame_per_sec.size() <= interations:
		frame_per_sec.append(int(string.length()))
	else:
		frame_per_sec[interations] = int(string.length())
	interations += 1
	if interations >= array_size:
		interations = 0
	var kbps = 0
	for i in frame_per_sec:
		if not i == null:
			if not i == 0:
				kbps += i
	var final = kbps * get_node("/root/Singleton").framerate * 8 / 600 / 1000 * (100-packetloss) / 100
	get_node("pinglist/Label3").set_text(str(final) + " kbps o data being used")
	get_node("pinglist/Label").set_text("total players:" + str(pinglist.keys().size()))

#commands
func id(var key_id,var arg):
	pass

func data(var key_id,var arg):
	if key_id == id:
		get_node("chat/Label").set_text(arg)
	pass

func pwd(var key_id,var arg):
	pass

var norepeat = {}
func time(var key_id,var arg):
#	data = recive_data.duplicate()
	i = key_id
	var ping = int(arg.sys)
	if key_id == id:
		if norepeat.has(str(i)):
			if norepeat[str(i)] == ping:
				return
			var time = int(os_time() - ping)
			get_node("/root/Singleton").ping = time
			if time > 0:
				pinglist[str(i)] = time
		norepeat[str(i)] = ping
	else:
		if pinglist.has(i):
			if arg.has("ping"):
				pinglist[str(i)] = arg.ping
	if not pinglist.has(i):
		pinglist[str(i)] = "connecting..."


func _on_Button_button_down():
	get_node("/root/Singleton").PORT = int(get_node("pinglist/TextEdit").get_text())
	get_tree().reload_current_scene()
#	packet[0].disconnect_from_host()
	pass # Replace with function body.

func _on_backtobrowse_button_down():
	get_node("/root/Singleton").PORT = get_node("/root/Singleton").BROWSE_PORT
#	packet[0].disconnect_from_host()
	get_tree().change_scene("res://ServerBrowse.tscn")
	pass # Replace with function body.

func _on_Timer_timeout():
	for i in pinglist.keys():
		if not recive_data.has(i):
			pinglist.erase(i)

func _on_Timer2_timeout():
	reconect()
	pass # Replace with function body.

func _on_Timer3_timeout():
	var framerate = get_node("/root/Singleton").framerate
	var mul = 100.0 / framerate
	packetloss = int((framerate-packetcount)*mul)
	get_node("pinglist/Label4").set_text(str(packetloss) + "% of packet loss")
	packetcount = 0
	pass # Replace with function body.

func _on_CheckButton_toggled(button_pressed):
	lagmod = button_pressed
	pass # Replace with function body.
