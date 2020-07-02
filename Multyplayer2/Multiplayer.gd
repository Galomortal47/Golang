extends Node

var file = File.new()
var packet = StreamPeerTCP.new()
var i = 0
var data
var string = ""
var recive_data = {}
var json = {"id":"8082","data":"test1", "time": 0}
var connect = true
var refresh_frames = 0

func _ready():
	print("tcp")
#	packet.connect_to_host( "::1", 8082)
	packet.connect_to_host( "127.0.0.1", 8081)
#	packet.set_no_delay(true)
	print("connected")

func _physics_process(delta):
	ping()
	refresh_frames += 1
	if  refresh_frames > 60:
		pinglist()
		refresh_frames = 0
	if not packet.is_connected_to_host():
			packet.connect_to_host( "127.0.0.1", 8081)
	var peerstream = PacketPeerStream.new()
	peerstream.set_stream_peer(packet)
	if peerstream.get_available_packet_count() > 0:
		data = (peerstream.get_packet())
		string = data.get_string_from_ascii()
		recive_data = parse_json(string)
#		print(recive_data)
	packet.put_string(to_json(json) + "\n")


func ping():
	json["time"] = str(OS.get_system_time_msecs())
#	if recive_data.has(json["id"]):
#		var printer = recive_data.duplicate()
#		print(OS.get_system_time_msecs() - int((printer[json["id"]]["Object"])["time"]))
#

func pinglist():
	var pinglist = {}
	data = recive_data.duplicate()
	for i in data.keys():
		if data.has(i):
#			print(data)
			pinglist[str(i)] = OS.get_system_time_msecs() - int(data[str(i)]["Object"]["time"])
	get_node("pinglist/RichTextLabel").set_text(str(pinglist))
