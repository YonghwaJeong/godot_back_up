extends Node

var item_list = Array()

func _ready():
	var directory = Directory.new()
	directory.open("res://Item")
	directory.list_dir_begin()
	
	var filename = directory.get_next()
	while(filename):
		if not directory.current_is_dir():
			item_list.append(load("res://Item/%s" % filename))
		
		filename = directory.get_next()
	
	directory.list_dir_end()

func get_item(item):
	for i in item_list:
		if i.name == item:
			return i
	return null
