extends Area2D

var item_list = Array()
var path = PoolVector2Array()
var watering_path = Array()
var path_with_distance = Array()	
var tilemap : TileMap
var pet : KinematicBody2D
var hoed : TileMap
var watered : TileMap
signal list_complete
enum {WATERING, COLLECTING, REST}

class customSort:
	static func distanceSort(a,b):
		if a[1] < b[1]:
			return true
		return false

func _ready():
	
	yield(get_tree().create_timer(1), "timeout")
	
func _process(delta):
	
	if !(pet):
		return
	
	if (pet.on_moving):
		return
		
	match pet.currentState:
		
		WATERING:
			
			if hoed.get_used_cells().size() == 0:
				return
			
			watering_path.clear()
			path_with_distance.clear()
				
			for cell in hoed.get_used_cells():
				if !(watered.get_used_cells().has(cell)):
					watering_path.append(cell)
			
			if watering_path.size() == 0:
				return
			
			for cell in watering_path:
				path_with_distance.append([cell, tilemap.get_distance_between(tilemap.world_to_map(pet.global_position), cell)])
			
			path_with_distance.sort_custom(customSort, "distanceSort")
			tilemap.call_deferred("set_path", tilemap.world_to_map(pet.global_position), path_with_distance[0][0])

		COLLECTING:
			
			if get_overlapping_bodies().size() == 0:
				return
			
			item_list.clear()
			for item in get_overlapping_bodies():
				if tilemap.get_used_cells().has(tilemap.world_to_map(item.global_position)):
					var astar_distance = tilemap.get_distance_between(tilemap.world_to_map(pet.global_position), tilemap.world_to_map(item.global_position))
					if astar_distance != 0:
						item_list.append([item, astar_distance])
					
			if item_list.size() == 0:
				return
			
			item_list.sort_custom(customSort, "distanceSort")
			tilemap.call_deferred("set_path", tilemap.world_to_map(pet.global_position), tilemap.world_to_map(item_list[0][0].global_position))
			
		REST:
			pass
