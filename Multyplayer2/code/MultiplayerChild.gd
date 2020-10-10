extends Multyplayer

var ping_rate = 2

func _ready():
	get_node("pinglist/Label2").set_text("lobby: #" + str(get_node('/root/Singleton').PORT))
	get_node("pinglist/TextEdit").set_text(str(get_node('/root/Singleton').PORT))

func _physics_process(delta):
	kbps_calc()
	for key in recive_data.keys():
		for key2 in recive_data[key]:
#			if get_script().get_script_method_list().has(key2):
			callv(key2,[key,recive_data[key][key2]])

var frame_per_sec = [0]
var interations = 0
var array_size = 1000
func kbps_calc():
	if frame_per_sec.size() <= interations:
		frame_per_sec.append(int((string.length()) * get_node("/root/Singleton").framerate * 8 / 1000))
	else:
		frame_per_sec[interations] = int((string.length()) * get_node("/root/Singleton").framerate * 8 / 1000)
	interations += 1
	if interations >= array_size:
		interations = 0
	var kbps = 0
	for i in frame_per_sec:
		if not i == null:
			if not i == 0:
				kbps += i
	get_node("pinglist/Label3").set_text(str(kbps/frame_per_sec.size()) + " kbps o data being used")
	

#commands
func id(var key_id,var arg):
	pass

func pwd(var key_id,var arg):
	pass

var pinglist = {}
var norepeat = {}
var OStimelist = {}
func time(var key_id,var arg):
	ping(key_id, arg)
	pass
 
func ping(var key_id, var arg):
	data = recive_data.duplicate()
	i = key_id
	var ping = int(arg)
	if norepeat.has(str(i)):
		print(i + " " + str(ping))
		if norepeat[str(i)] == ping:
			return
		var time = (OStimelist[str(i)] - ping - (1000  / get_node("/root/Singleton").framerate * 2)) * -1
		print(time)
		pinglist[str(i)] = time
	norepeat[str(i)] = ping
	OStimelist[str(i)] = ping + (1000  / ping_rate)
	if not pinglist.has(i):
		pinglist[str(i)] = "loading"
	for i in pinglist.keys():
		if not data.has(i):
			pinglist.erase(i)
	var gigatext = ""
	for i in pinglist.keys():
		var color = "white"
		if int(pinglist[i]) > 100:
			color = 'yellow'
		if int(pinglist[i]) > 200:
			color = 'red'
		if i == id:
			color = 'aqua'
		gigatext += "[color="  + color + "]" + str(i) + " : ping : " + str(pinglist[i]) + "[/color]\n"
	get_node("pinglist/RichTextLabel").set_bbcode(gigatext)
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


func _on_Timer_timeout():
	json["time"] = str(OS.get_system_time_msecs())
	pass # Replace with function body.
