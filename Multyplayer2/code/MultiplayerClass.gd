extends Node
class_name Multyplayer

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
#	packet.set_no_delay(true)
	print("connected")

func _physics_process(delta):
	if not packet.is_connected_to_host():
			packet.connect_to_host( get_node("/root/Singleton").Ip, get_node("/root/Singleton").PORT)
			print(get_node("/root/Singleton").PORT)
	var peerstream = PacketPeerStream.new()
	peerstream.set_stream_peer(packet)
	if peerstream.get_available_packet_count() > 0:
		data = (peerstream.get_packet())
		string = data.get_string_from_ascii()
		recive_data = parse_json(string)
		print(string)
	packet.put_string(to_json(json) + "\n")
