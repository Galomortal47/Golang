extends Node
class_name clsnycudp

var file = File.new()
var socketUDP = PacketPeerUDP.new()
var i = 0
var data
var string
var recive_data = {}
var json = {"id":"8082","data":"test", "time": 0}
var time = 0
var gen_id

func _ready():
	randomize()
	json["id"] = str(int(rand_range(0,10000)))
	print("udp")
#	packet.connect_to_host( "::1", 8082)
	socketUDP.set_dest_address( "127.0.0.1", 10001)
	socketUDP.listen(10002, "*")
	print("connected")

func _physics_process(delta):
	ping()
	if socketUDP.get_available_packet_count() > 0:
		data = (socketUDP.get_packet())
		string = data.get_string_from_ascii()
#		print(string.length())
		recive_data = parse_json(string)
#		print(recive_data)
	var packet = to_json(json)
	socketUDP.put_var(str(packet))
#	print(string)

func _exit_tree():
	json["Destroy"] = "true"
	socketUDP.close()

func ping():
	json["time"] = str(OS.get_system_time_secs())
	if recive_data.has(json["id"]):
		var printer = recive_data.duplicate()
#		print(OS.get_system_time_secs() - int(parse_json(printer[json["id"]]["Object"])["time"]))
