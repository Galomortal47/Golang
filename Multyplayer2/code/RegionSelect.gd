extends Node

var servernamelist = ["south america","north america","local"]
var serverlist = ["189.126.106.201","104.207.129.209","127.0.0.1"]

func _ready():
	for i in servernamelist:
		get_node("ItemList").add_item(i)

func _on_ItemList_item_activated(index):
	get_node("/root/Singleton").Ip = serverlist[index]
	get_tree().change_scene("res://ServerBrowse.tscn")
	pass # Replace with function body.
