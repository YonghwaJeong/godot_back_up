extends Control

onready var leg = $Leg
onready var body = $Body
onready var arm = $Arm
onready var shirts = $Shirts
onready var hair = $Hair
onready var acc = $Acc

signal hair_changed(current_hair)
signal shirts_changed(current_shirts)
signal acc_changed(current_acc)

# Defaults
var next_skin : int = 1 
var previous_skin : int = 24
var current_hair : int = 0
var current_shirts : int = 0
var current_acc : int = 19

# Skin setting
func _on_Skin_Next_pressed():
	body.material.set_shader_param("replace_palette", load("res://Assets/Skin_Palettes/skin%d.png" %next_skin))
	arm.material.set_shader_param("replace_palette", load("res://Assets/Skin_Palettes/skin%d.png" %next_skin))
	next_skin += 1
	previous_skin += 1
	if next_skin > 24:
		next_skin = 0
	if previous_skin > 24:
		previous_skin = 0

func _on_Skin_Previous_pressed():
	body.material.set_shader_param("replace_palette", load("res://Assets/Skin_Palettes/skin%d.png" %previous_skin))
	arm.material.set_shader_param("replace_palette", load("res://Assets/Skin_Palettes/skin%d.png" %previous_skin))
	next_skin -= 1
	previous_skin -= 1
	if next_skin < 0:
		next_skin = 24
	if previous_skin < 0:
		previous_skin = 24

func _on_Hair_Next_pressed():
	current_hair += 1
	if current_hair > 31:
		current_hair = 0
	set_current_hair(current_hair)

func _on_Hair_Previous_pressed():
	current_hair -= 1
	if current_hair < 0:
		current_hair = 31
	set_current_hair(current_hair)
	
func _on_Shirts_Next_pressed():
	current_shirts += 1
	if current_shirts > 111:
		current_shirts = 0
	set_current_shirts(current_shirts)

func _on_Shirts_Previous_pressed():
	current_shirts -= 1
	if current_shirts < 0:
		current_shirts = 111
	set_current_shirts(current_shirts)
	
func _on_Acc_Next_pressed():
	current_acc += 1
	if current_acc > 19:
		current_acc = 0
	set_current_acc(current_acc)

func _on_Acc_Previous_pressed():
	current_acc -= 1
	if current_acc < 0:
		current_acc = 19
	set_current_acc(current_acc)

func set_current_hair(current_hair):
	var quotient = floor(current_hair/8)
	var remainder = current_hair - quotient*8 
	hair.texture.region.position = Vector2(783+(remainder*16),5+(quotient*96))
	emit_signal("hair_changed", current_hair)

func set_current_shirts(current_shirts):
	var quotient = floor(current_shirts/16)
	var remainder = current_shirts - quotient*16 
	shirts.texture.region.position = Vector2(783+(remainder*8),394+(quotient*32))
	emit_signal("shirts_changed", current_shirts)

func set_current_acc(current_acc):
	var quotient = floor(current_acc/8)
	var remainder = current_acc - quotient*8 
	acc.texture.region.position = Vector2(250+(remainder*16),682+(quotient*32))
	emit_signal("acc_changed", current_acc)

func _on_Hair_color_hair_color_changed(hue_value, saturation_value, brightness_value):
	hair.set_modulate(Color.from_hsv(hue_value, saturation_value, brightness_value, 1))

func _on_Pants_color_pants_color_changed(hue_value, saturation_value, brightness_value):
	leg.set_modulate(Color.from_hsv(hue_value, saturation_value, brightness_value, 1))

func _on_Eyes_color_eyes_color_changed(hue_value, saturation_value, brightness_value):
	body.material.set_shader_param("eye_color", Color.from_hsv(hue_value, saturation_value, brightness_value,1))
