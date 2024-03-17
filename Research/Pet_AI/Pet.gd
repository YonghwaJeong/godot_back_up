extends KinematicBody2D

var speed : int = 100
var velocity = Vector2.ZERO

var path = Array()
var navigation : Navigation2D = null
var item_list : = Array()
var destination : Vector2 
onready var line2d = $Line2D

func _ready():
	
	set_physics_process(false)
	yield(get_tree(), "idle_frame")
	
	var tree = get_tree()
	if tree.has_group("Navigation"):
		navigation = tree.get_nodes_in_group("Navigation")[0]

func _physics_process(delta):
	line2d.global_position = Vector2.ZERO
	if navigation:
		generate_path(item_list)
		navigate()
	move()
		
func generate_path(item_list : Array):
	
	if navigation != null:
		destination = item_list[0][0].position
		path = navigation.get_simple_path(self.position, destination, true)
		line2d.points = path
		
	if position.distance_to(destination) < 1:
		velocity = Vector2.ZERO
		print("On point")
		item_list.pop_front()
		
	if item_list.size() == 0 :
		set_physics_process(false)
		print("complete")
		
func navigate():
	if path.size() > 0:
		velocity = position.direction_to(path[1]) * speed
		
	if position == path[0]:
		path.remove(0)
	
func move():
	velocity = move_and_slide(velocity)
	
func start_searching():
	yield(get_tree().create_timer(0.5), "timeout")
	item_list = $Sight.item_list
	set_physics_process(true)
