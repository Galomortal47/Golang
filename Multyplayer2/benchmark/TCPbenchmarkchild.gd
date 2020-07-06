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
var index = 0

func _ready():
#	packet.connect_to_host( "::1", 8082)
	json.id = "player" + str(index)
	packet.connect_to_host( "127.0.0.1", 8081)
	packet.set_no_delay(true)


func _physics_process(delta):
	ping()
	if not packet.is_connected_to_host():
			packet.connect_to_host( "127.0.0.1", 8081)
	var peerstream = PacketPeerStream.new()
	peerstream.set_stream_peer(packet)
	if peerstream.get_available_packet_count() > 0:
		data = (peerstream.get_packet())
		string = data.get_string_from_ascii()
		recive_data = parse_json(string)
	packet.put_string(to_json(json) + "\n")

func ping():
	json["time"] = str(OS.get_system_time_msecs())
