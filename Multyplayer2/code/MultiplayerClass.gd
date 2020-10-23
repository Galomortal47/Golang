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
var packetcount = 0

var lagmod = false
var receiver = true

func rng():
	randomize()
	return str(int(rand_range(0,10000)))

func _ready():
#	packet.set_no_delay(false)
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
		packetcount += 1
		if lagmod:
			receiver = false
		else:
			receiver = true
		if not receiver:
			packet.put_string(to_json(json))
		#print(string)
#		print(recive_data)
#	packet.put_string("\n")
	if receiver:
		packet.put_string(to_json(json))
#	packet.put_string("\n")
	json = {}
 
