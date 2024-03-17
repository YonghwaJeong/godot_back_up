extends TextureRect

export var item : Resource
export var quantity : int = 0
var player = GameManager.player
var is_mouse_entered = false
signal inventory_slot_changed

func _ready():
	connect("mouse_entered", self, "set_mouse_state")
	connect("mouse_exited", self, "set_mouse_state")
	connect("visibility_changed", self, "adjust_mouse_state")
	visual_update()

func visual_update():
		
	if item != null:
		get_child(0).get_child(0).texture = item.texture
		if quantity > 1:
			get_child(1).text = "%d" %quantity
		else:
			get_child(1).text = ""
	else:
		get_child(0).get_child(0).texture = null
		get_child(1).text = ""

func set_mouse_state():
	is_mouse_entered = !is_mouse_entered

func adjust_mouse_state():
	if is_mouse_entered:
		is_mouse_entered = false

func _input(event):
	if !(is_mouse_entered):
		return
	if !(event is InputEventMouseButton):
		return
	if !(event.button_index == BUTTON_LEFT and event.pressed):
		return
	if event.shift and item != null:
		if get_parent().name == "InventoryGrid":
			player.inventory.add_item(player.inventory.chest_slots, item.name, quantity)
			self.item = null
			self.quantity = 0
			emit_signal("inventory_slot_changed")
		elif get_parent().name == "ChestGrid":
			player.inventory.add_item(player.inventory.interacting_inv_slots, item.name, quantity)
			self.item = null
			self.quantity = 0
			emit_signal("inventory_slot_changed")

func get_drag_data(_position):

	if item == null:
		return
		
	var data = {
		"item" : item,
		"quantity" : quantity,
		"origin" : self
	}
	
	# set drag preview
	var drag_image = TextureRect.new()
	drag_image.texture = item.texture
	drag_image.rect_size = Vector2(32,32)
	drag_image.rect_scale = Vector2(28/drag_image.rect_size.x, 28/drag_image.rect_size.y)
	
	var control = Control.new()
	control.add_child(drag_image)
	drag_image.rect_position = -0.45 * drag_image.rect_size
	set_drag_preview(control)

	return data
	
func can_drop_data(_position, data):
	return true
	
func drop_data(_position, data):
	
	var target_item = item
	var target_quantity = quantity
	var origin_slot = data["origin"]
	
	item = data["item"]
	quantity = data["quantity"]
	origin_slot.item = target_item
	origin_slot.quantity = target_quantity
	emit_signal("inventory_slot_changed")
