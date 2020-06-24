extends Node

var file = File.new()
var packet = StreamPeerTCP.new()
var i = 0
var data
var string
var recive_data = {}
var json = {"id":"8082","data":"test1", "time": 0}
var connect = true

func _ready():
	print("tcp")
#	packet.connect_to_host( "::1", 8082)
	packet.connect_to_host( "127.0.0.1", 8081)
#	packet.set_no_delay(true)
	print("connected")

func _physics_process(delta):
	if not packet.is_connected_to_host():
			packet.connect_to_host( "127.0.0.1", 8081)
	var peerstream = PacketPeerStream.new()
	peerstream.set_stream_peer(packet)
	if peerstream.get_available_packet_count() > 0:
		data = (peerstream.get_packet())
		string = data.get_string_from_utf8()
		recive_data = parse_json(string)
		print(string)
	packet.put_string(to_json(json) + "\n")


func ping():
	json["time"] = str(OS.get_system_time_secs())
	if recive_data.has(json["id"]):
		var printer = recive_data.duplicate()
#		print(OS.get_system_time_secs() - int(parse_json(printer[json["id"]]["Object"])["time"]))
