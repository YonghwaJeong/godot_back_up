extends KinematicBody2D

var speed : int = 100
var velocity = Vector2.ZERO

var path = Array()
var navigation : Navigation2D = null
var destination : Vector2
var is_on_point : bool = true
onready var line2d = $Line2D

func _ready():
	
	yield(get_tree(), "idle_frame")
	
	var tree = get_tree()
	if tree.has_group("Navigation"):
		navigation = tree.get_nodes_in_group("Navigation")[0]

func _physics_process(delta):
	line2d.global_position = Vector2.ZERO
	if !(is_on_point) and navigation:
		generate_path(destination)
		navigate()
	move()
		
func generate_path(pos : Vector2):
	if navigation != null:
		path = navigation.get_simple_path(self.position, pos, true)
		line2d.points = path
		
	if position.distance_to(destination) < 0.01:
		velocity = Vector2.ZERO
		is_on_point = false
		print("On point")
		
func navigate():
	if path.size() > 0:
		velocity = position.direction_to(path[1]) * speed
		
	if position == path[0]:
		path.remove(0)
	
func move():
	velocity = move_and_slide(velocity)
