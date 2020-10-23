extends Node
class_name MultyplayerMultiThread

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
var thread = 0
var nthreads = 4
var packet = gen_connections(nthreads)

func gen_connections(var integer):
	var array = []
	for i in range(0,integer):
		array.append(StreamPeerTCP.new())
	return array

func rng():
	randomize()
	return str(int(rand_range(0,10000)))

func _ready():
#	packet.set_no_delay(false)
	for i in range(0,nthreads):
		packet[i].connect_to_host( get_node("/root/Singleton").Ip, get_node("/root/Singleton").PORT)
	var timer = Timer.new()
	timer.autostart = true
	timer.wait_time = 1.0 / get_node("/root/Singleton").framerate
	timer.connect("timeout",self,"_sync")
	add_child(timer)

func _sync():
	thread += 1
	if thread == nthreads:
		thread = 0
	json.id = id
	json.pwd = get_node("/root/Singleton").password
	if not packet[thread].is_connected_to_host():
			packet[thread].connect_to_host( get_node("/root/Singleton").Ip, get_node("/root/Singleton").PORT)
	peerstream.set_stream_peer(packet[thread])
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
		packet[thread].put_string(to_json(json))# + gen_size_msg(to_json(json)))
#	packet.put_string("\n")
	json = {}
 
func gen_size_msg(var string):
	if string.length() < 10:
		return "000" + str(string.length())
	if string.length() < 100:
		return "00" + str(string.length())
	if string.length() < 1000:
		return "0" + str(string.length())
	return str(string.length())
