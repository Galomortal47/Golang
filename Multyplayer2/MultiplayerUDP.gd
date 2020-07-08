extends Node
class_name clsnycudp

var file = File.new()
var socketUDP = PacketPeerUDP.new()
var i = 0
var data
var string
var recive_data = {}
var json = {"id":"8082", "time": 0}
var time = 0
var gen_id
var refresh_frames = 0

func _ready():
	randomize()
	json["id"] = "HOST"
	print("udp")
	socketUDP.set_dest_address( "127.0.0.1", 10001)
	socketUDP.listen(10002, "*")
	print("connected")

func _physics_process(delta):
	ping()
	refresh_frames += 1
	if  refresh_frames > 60:
		pinglist()
		refresh_frames = 0
	if socketUDP.get_available_packet_count() > 0:
		data = (socketUDP.get_packet())
		string = data.get_string_from_ascii()
		recive_data = parse_json(string)
	var packet = to_json(json)
	socketUDP.put_var(str(packet))

func _exit_tree():
	json["Destroy"] = "true"
	socketUDP.close()

func ping():
	json["time"] = str(OS.get_system_time_msecs())

func pinglist():
	var pinglist = {}
	data = recive_data.duplicate()
	for i in data.keys():
		if data.has(i):
			var time = parse_json(data[str(i)]["Object"])
			print(time)
			if time != null:
				pinglist[time.id] = OS.get_system_time_msecs() - int(time["time"])
	get_node("pinglist/RichTextLabel").set_text(str(pinglist))
