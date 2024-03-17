extends Node2D

func _ready():
	yield(get_tree(), "idle_frame")
	$TileMap.player = $Player
	$Player.tilemap = $TileMap
	$Player.watered = $Watered
	$Player/Detectable.tilemap = $TileMap
	$Player/Detectable.player = $Player
	$Player/Detectable.hoed = $Hoed
	$Player/Detectable.watered = $Watered
	$Player/AnimationTree.active = true

func _input(event):
	if (event is InputEventMouseButton && event.is_pressed() && event.button_index == BUTTON_RIGHT):
		$Watered.set_cellv($TileMap.world_to_map(get_global_mouse_position()), 1)
