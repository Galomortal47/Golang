extends Multyplayer

var browse_list = []
var json_list = []

func _ready():
	get_node("pinglist/ItemList").add_item("loading...")


func _physics_process(delta):
	var spliter = string.lstrip("[")
	spliter = spliter.split("},")
	spliter = Array(spliter)
	browse_list = []
	for i in spliter:
			var piece = i + "}"
			if validate_json(piece) == "":
				var json = parse_json(piece)
				var space = "         "
				if json.has('currplayer'):
					var line = "players: " + json.currplayer + "/" + json.maxplayers
					var line2 = line + space +" map: " + json.map + space + " gamemode: " 
					var line3 = line2 + json.gamemode + space + " name: " + json.servername
					var line4 = line3 
					if json.has("ip"):
						line4 += space + " ip:" + json.ip
					browse_list.append(str(line4))
					json_list.append(json)
	pass
 
func _on_ItemList_item_selected(index):
	var port = int((json_list[index]["port"]).lstrip(":"))
	get_node("/root/Singleton").PORT = port
	get_tree().change_scene("res://Multyplayer.tscn")
	print(port)
	pass # Replace with function body.

func load_server_list():
	get_node("pinglist/ItemList").clear()
	for i in browse_list:
		get_node("pinglist/ItemList").add_item(str(i))
	pass # Replace with function body.

func _on_Timer_timeout():
	load_server_list()

func _on_Button_button_down():
	get_tree().change_scene("res://RegionSelect.tscn")
#	packet.disconnect_from_host()
	pass # Replace with function body.

func _on_Button3_button_down():
	get_node("/root/Singleton").PORT = int(get_node("TextEdit").get_text())
	get_tree().change_scene("res://Multyplayer.tscn")
#	packet.disconnect_from_host()
	pass # Replace with function body.
