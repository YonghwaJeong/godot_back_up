extends Area2D

signal add_item

func _ready():
	connect("add_item", get_parent(), "inventory_add_item")

func _physics_process(delta):
	if get_overlapping_bodies().size() == 0:
		return
	var items = get_overlapping_bodies()
	var center_point = global_position + Vector2(0,16)
	for item in items:
		if item.dragable == false:
			return
		item.velocity += item.global_position.direction_to(center_point) * 0.5
		if item.global_position.distance_to(center_point) < 6:
			emit_signal("add_item", item.item.name)
			item.queue_free()
