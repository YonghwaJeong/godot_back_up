extends Resource

class_name Inventory

signal inventory_changed
export var slots = Array() setget set_slots, get_slots
export var hotbar_slots = Array()
export var chest_slots = Array()
export var interacting_inv_slots = Array()
export var inventory_max_size : int = 36
export var hotbar_max_size : int = 12
export var disabled_slots : int = 0

func set_slots(new_slots : Array):
	slots = new_slots
	emit_signal("inventory_changed", self)
	
func get_slots():
	return slots
	
func add_item(slots, item_name, quantity):
	if quantity <= 0:
		return 
	
	var item = ItemDatabase.get_item(item_name)
	if not item:
		print("Item not found")
		return
	
	# Stacking
	var remaining_quantity = quantity
	var max_stack_size = item.max_stack_size
	
	if item.stackable:
		# check for 'all' items in inventory
		# when add and stacking items automatically
		for i in slots.size():
			# no more items to add in
			if remaining_quantity == 0:
				break
			var inventory_slot = slots[i]
			# if not a same item
			if inventory_slot.item == null:
				continue
			
			if inventory_slot.item.name != item.name :
				continue
			
			if inventory_slot.quantity < max_stack_size:
				var original_quantity = inventory_slot.quantity
				inventory_slot.quantity = min(original_quantity + remaining_quantity, max_stack_size)
				remaining_quantity -= inventory_slot.quantity - original_quantity
				
	while remaining_quantity > 0:
		# this is the part, that gives item_reference & quantity properties
		# to items those 'just' be added
		var new_item = {
			item_reference = item,
			quantity = min(remaining_quantity, max_stack_size)
		}		
		for slot in slots:
			if slot.item != null:
				continue
			slot.item = new_item.item_reference
			slot.quantity = new_item.quantity
			break
		
		remaining_quantity -= new_item.quantity
	
	inventory_to_hotbar()
	emit_signal("inventory_changed", self)	

func delete_all():
	for slot in slots:
		slot.item = null
		slot.quantity = 0
	emit_signal("inventory_changed", self)

func _on_inventory_slot_changed():
	emit_signal("inventory_changed", self)	

func hotbar_to_inventory():
	for i in hotbar_max_size:
		slots[i].item = hotbar_slots[i].item
		slots[i].quantity = hotbar_slots[i].quantity
	emit_signal("inventory_changed", self)	
	
func inventory_to_hotbar():
	if hotbar_slots.size() == 0:
		return
	for i in hotbar_max_size:
		hotbar_slots[i].item = slots[i].item
		hotbar_slots[i].quantity = slots[i].quantity
	emit_signal("inventory_changed", self)

func inventory_to_interacting_inv():
	if interacting_inv_slots.size() == 0:
		return
	for i in inventory_max_size:
		interacting_inv_slots[i].item = slots[i].item
		interacting_inv_slots[i].quantity = slots[i].quantity
	emit_signal("inventory_changed", self)

func close_chest_interaction():
	
	for i in inventory_max_size:
		slots[i].item = interacting_inv_slots[i].item
		slots[i].quantity = interacting_inv_slots[i].quantity
	for i in hotbar_max_size:
		hotbar_slots[i].item = interacting_inv_slots[i].item
		hotbar_slots[i].quantity = interacting_inv_slots[i].quantity	
	for i in chest_slots.size():
		chest_slots[i].item = null
		chest_slots[i].quantity = 0
		
	emit_signal("inventory_changed", self)

func record_data():
	var data_array = Array()
	var save_file = File.new()
	save_file.open("res://Save/inventory_data.txt", File.WRITE)
	for i in slots.size():
		var save_data = {
			"item" : slots[i].item,
			"quantity" : slots[i].quantity
		}
		data_array.append(save_data)
	save_file.store_string(var2str(data_array))
	save_file.close()

func load_data():
	var load_file = File.new()
	load_file.open("res://Save/inventory_data.txt", File.READ)
	var data = load_file.get_as_text()
	return str2var(data)

func save_chest_data(address):
	var data_array = Array()
	var save_file = File.new()
	save_file.open("res://Save/%s.txt" %address, File.WRITE)
	for i in slots.size():
		var save_data = {
			"item" : chest_slots[i].item,
			"quantity" : chest_slots[i].quantity
		}
		data_array.append(save_data)
	save_file.store_string(var2str(data_array))
	save_file.close()
	
func load_chest_data(address):
	var load_file = File.new()
	if load_file.file_exists("res://Save/%s.txt" %address):
		load_file.open("res://Save/%s.txt" %address, File.READ)
		var data = str2var(load_file.get_as_text())	
		for i in data.size():
			chest_slots[i].item = data[i].item
			chest_slots[i].quantity = data[i].quantity
