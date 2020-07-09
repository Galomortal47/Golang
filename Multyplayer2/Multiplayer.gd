extends Node

var file = File.new()
var packet = StreamPeerTCP.new()
var i = 0
var data
var string = ""
var recive_data = {}
var json = {"id":"player82","data":"test1", "time": 0}
var connect = true
var refresh_frames = 0

func _ready():
	print("tcp")
	packet.set_no_delay(true)
	print("connected")

func _physics_process(delta):
	ping()
	refresh_frames += 1
	if  refresh_frames > 60:
		pinglist()
		refresh_frames = 0
	if not packet.is_connected_to_host():
			packet.connect_to_host( get_node("/root/Singleton").Ip, get_node("/root/Singleton").PORT)
			print(get_node("/root/Singleton").PORT)
	var peerstream = PacketPeerStream.new()
	peerstream.set_stream_peer(packet)
	if peerstream.get_available_packet_count() > 0:
		data = (peerstream.get_packet())
		string = data.get_string_from_ascii()
		recive_data = parse_json(string)
	packet.put_string(to_json(json) + "\n")


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


