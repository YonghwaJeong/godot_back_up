extends Area2D

var item_list = Array()
signal list_complete

class customSort:
	static func distanceSort(a,b):
		if a[1] < b[1]:
			return true
		return false

func _ready():
	
	yield(get_tree(), "idle_frame")
	connect("list_complete", get_parent(), "start_searching")
	
	for item in get_overlapping_bodies():
		item_list.append([item, item.position.distance_to(get_parent().position)])
	
	item_list.sort_custom(customSort, "distanceSort")
	emit_signal("list_complete")
