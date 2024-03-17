extends TileMap
class_name Astar_Path

onready var astar = AStar2D.new()
onready var used_cells = get_used_cells()

var path : PoolVector2Array

func _ready():
	yield(get_tree(), "idle_frame")
	add_all_points_except()
	connect_all_points()

# generate unique id for cells
func id(point):
	var a = point.x
	var b = point.y
	return (a+b) * (a+b+1) / 2+b

func add_all_points_except():
	var obstacle_list : Array = get_tree().get_nodes_in_group("Obstacle")
	var obstacle_pos = PoolVector2Array()
	for obstacle in obstacle_list:
		obstacle_pos.append(world_to_map(obstacle.global_position))
		
	for cell in used_cells:
		astar.add_point(id(cell), cell, 1.0)
		
	for cell in obstacle_pos:
		astar.set_point_disabled(id(cell))
	
	print("added points")
		
func connect_all_points():
	for cell in used_cells:
		var neighbor_vector = [Vector2(1,0), Vector2(0,1), Vector2(-1,0), Vector2(0,-1)]
		for vector in neighbor_vector:
			var next_cell = cell + vector
			if used_cells.has(next_cell):
				astar.connect_points(id(cell), id(next_cell), false)
	print("connected points")
	
func get_astar_path(start, end):
	path = astar.get_point_path(id(start), id(end))
	if path.size() != 0:
		path.remove(0)

func get_distance_between(start, end):
	var point_path = astar.get_point_path(id(start), id(end))
	return point_path.size()
