extends KinematicBody2D

var player_resource = preload("res://Player/Player_Setting.tres")
var player_tracker = preload("res://Player/Player_Tracker.tres")
var inventory_resource = load("res://Script/Inventory/Inventory.gd")
var inventory = inventory_resource.new()
signal player_onready

onready var leg = $Leg
onready var body = $Body
onready var shirts = $Shirts
onready var hair = $Hair
onready var arm = $Arm
onready var acc = $Acc
onready var tool_hitbox = $ToolHitbox/CollisionShape2D
onready var weapon_hitbox = $WeaponHitbox/CollisionShape2D
onready var farming_tool = $Toolbox/Tool
onready var weapon = $Weaponbox/Weapon
onready var collider = $CollisionShape2D

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
var velocity = Vector2.ZERO
var facing_direction : Vector2
var current_tool : Resource
export var walk_speed = 5000
enum {MOVE, ATTACK, HOE, WATERING, FISHING, MINING, LUMBERING}
var state = MOVE
var seedable = true

func _ready():
	tool_hitbox.disabled = true
	weapon_hitbox.disabled = true
	global_position = player_tracker.player_position
	connect("player_onready", GameManager, "_on_player_onready")
	emit_signal("player_onready", self)
	leg.set_modulate(player_resource.pants_color)
	body.material.set_shader_param("replace_palette", load("res://Assets/Skin_Palettes/skin%d.png" %(player_resource.skin-1)))
	body.material.set_shader_param("eye_color", player_resource.eyes_color)
	set_hair_region(player_resource.hair)
	set_shirts_region(player_resource.shirts)
	set_acc_region(player_resource.acc)
	hair.set_modulate(player_resource.hair_color)
	set_initial_direction()

func set_initial_direction():
	facing_direction = player_tracker.last_direction
	animationTree.set("parameters/Idle/Idle/blend_position", facing_direction)
	animationTree.set("parameters/Walk/Walk/blend_position", facing_direction)
	animationTree.set("parameters/UseTool/UseTool/blend_position", facing_direction)
	animationTree.set("parameters/Attack/Attack/blend_position", facing_direction)

func set_direction(player_direction : Vector2):
	facing_direction = player_direction
	if facing_direction.x > 0:
		body.flip_h = false
	elif facing_direction.x < 0:
		body.flip_h = true
	animationTree.set("parameters/Idle/Idle/blend_position", facing_direction)
	animationTree.set("parameters/Walk/Walk/blend_position", facing_direction)
	animationTree.set("parameters/UseTool/UseTool/blend_position", facing_direction)
	animationTree.set("parameters/Attack/Attack/blend_position", facing_direction)

func set_hair_region(hair_num):
	var quotient = floor(hair_num/8)
	var remainder = hair_num - quotient*8 
	hair.texture.region.position = Vector2(783+(remainder*16),5+(quotient*96))
	hair.texture.region.size = Vector2(16,96)

func set_shirts_region(shirts_num):
	var quotient = floor(shirts_num/16)
	var remainder = shirts_num - quotient*16 
	shirts.texture.region.position = Vector2(783+(remainder*8),394+(quotient*32))
	shirts.texture.region.size = Vector2(8,32)
	
func set_acc_region(acc_num):
	var quotient = floor(acc_num/8)
	var remainder = acc_num - quotient*8 
	acc.texture.region.position = Vector2(250+(remainder*16),682+(quotient*32))
	acc.texture.region.size = Vector2(16,32)
	
func _physics_process(delta):
	
	match state:
		MOVE:
			move(delta)
		ATTACK:
			attack()
		HOE:
			use_hoe()
		WATERING:
			use_watering_can()
		FISHING:
			use_fishing_rod()
		MINING:
			use_pickaxe()
		LUMBERING:
			use_axe()
	
	sync_body_parts()
	
func sync_body_parts():
	leg.frame = body.frame
	arm.frame = body.frame
	leg.flip_h = body.flip_h
	arm.flip_h = body.flip_h
	hair.flip_h = body.flip_h
	acc.flip_h = body.flip_h
	farming_tool.flip_h = body.flip_h
	
func move(delta):
	var movement_vector = Vector2.ZERO
	movement_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	movement_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	if movement_vector != Vector2.ZERO:
		animationTree.set("parameters/Idle/Idle/blend_position", movement_vector)
		animationTree.set("parameters/Walk/Walk/blend_position", movement_vector)
		animationTree.set("parameters/UseTool/UseTool/blend_position", movement_vector)
		animationTree.set("parameters/Attack/Attack/blend_position", movement_vector)
		animationState.travel("Walk")
		velocity = movement_vector.normalized() * walk_speed * delta
	else:
		animationState.travel("Idle")
		velocity = Vector2.ZERO
	
	velocity = move_and_slide(velocity)
	
	if movement_vector.x > 0:
		body.flip_h = false
	elif movement_vector.x < 0:
		body.flip_h = true
	
func attack():
	var quotient = floor(current_tool.weapon_code/8)
	var remainder = current_tool.weapon_code - quotient*8
	weapon.texture.region = Rect2(remainder * 16, quotient * 16, 16, 16)
	animationState.travel("Attack")

func use_hoe():
	farming_tool.texture.region = Rect2(0, 28, 96, 20)
	animationState.travel("UseTool")

func use_watering_can():
	state = MOVE

func use_fishing_rod():
	pass

func use_pickaxe():
	farming_tool.texture.region = Rect2(0, 90, 96, 22)
	animationState.travel("UseTool")
	
func use_axe():
	farming_tool.texture.region = Rect2(0, 154, 96, 22)
	animationState.travel("UseTool")

func action_starting():
	farming_tool.visible = true

func action_finished():
	farming_tool.visible = false
	farming_tool.z_index = 0
	state = MOVE

func attack_starting():
	weapon.visible = true
	
func attack_finished():
	weapon.visible = false
	weapon.z_index = 0
	state = MOVE

func change_seedable():
	seedable = !seedable

func inventory_add_item(item_name):
	inventory.add_item(inventory.slots,item_name, 1)

func _on_Player_tree_exiting():
	inventory.hotbar_to_inventory()
	inventory.record_data()
	player_tracker.last_direction = animationTree.get("parameters/Idle/Idle/blend_position")
	ResourceSaver.save("res://Player/Player_Tracker.tres", player_tracker)
