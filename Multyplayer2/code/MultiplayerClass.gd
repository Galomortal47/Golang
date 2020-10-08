extends Node
class_name Multyplayer

var packet = StreamPeerTCP.new()
var i = 0
var data
var string = ""
var recive_data = {}
var json = {}
onready var id = "player" + rng()
var connect = true
var refresh_frames = 0
var peerstream = PacketPeerStream.new()

func rng():
	randomize()
	return str(int(rand_range(0,10000)))

func _ready():
	packet.connect_to_host( get_node("/root/Singleton").Ip, get_node("/root/Singleton").PORT)
	var timer = Timer.new()
	timer.autostart = true
	timer.wait_time = 1.0 / get_node("/root/Singleton").framerate
	timer.connect("timeout",self,"_sync")
	add_child(timer)

func _sync():
	json.id = id
	json.pwd = get_node("/root/Singleton").password
	if not packet.is_connected_to_host():
			packet.connect_to_host( get_node("/root/Singleton").Ip, get_node("/root/Singleton").PORT)
	peerstream.set_stream_peer(packet)
	if peerstream.get_available_packet_count() > 0:
		string = peerstream.get_packet().get_string_from_ascii()
		recive_data = parse_json(string)
		#print(string)
	packet.put_string(to_json(json) + "\n")
#	print(recive_data)
	json = {}
