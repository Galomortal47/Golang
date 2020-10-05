extends Node
class_name Multyplayer

var packet = StreamPeerTCP.new()
var i = 0
var data
var string = ""
var recive_data = {}
var json = {"id":"player182","data":"test1", "time": 0}
var connect = true
var refresh_frames = 0

func _ready():
	packet.connect_to_host( get_node("/root/Singleton").Ip, get_node("/root/Singleton").PORT)
	packet.set_no_delay(true)
	var timer = Timer.new()
	timer.autostart = true
	timer.wait_time = 1.0 / get_node("/root/Singleton").framerate
	timer.connect("timeout",self,"_sync")
	add_child(timer)

func _sync():
	json["time"] = str(OS.get_system_time_msecs())
	json["password"] = get_node("/root/Singleton").password
	if not packet.is_connected_to_host():
			packet.connect_to_host( get_node("/root/Singleton").Ip, get_node("/root/Singleton").PORT)
	var peerstream = PacketPeerStream.new()
	peerstream.set_stream_peer(packet)
	if peerstream.get_available_packet_count() > 0:
		data = (peerstream.get_packet())
		string = data.get_string_from_ascii()
		print(" ")
		print(string)
		recive_data = parse_json(string)
		#print(string)
	packet.put_string(to_json(json))
