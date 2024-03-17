extends YSort

func _ready():
	var player_scene = load("res://Player/Player.tscn")
	var new_player = player_scene.instance()
	add_child(new_player, true)
	new_player.set_owner(self)
