extends YSort

func _ready():
	var player_scene = load("res://Player/Player.tscn")
	var pet_scene = load("res://Scene/Pet.tscn")
	var new_player = player_scene.instance()
	var new_pet = pet_scene.instance()
	add_child(new_player, true)
	add_child(new_pet, true)
	new_player.set_owner(self)
	new_pet.set_owner(self)
	var camera = Camera2D.new()
	new_player.add_child(camera, true)
	camera.current = true
