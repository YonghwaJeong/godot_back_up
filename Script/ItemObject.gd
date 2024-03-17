extends KinematicBody2D

onready var sprite = $Sprite
onready var area = $ItemArea
var item : Resource
var velocity = Vector2.ZERO
var dragable = false

func _ready():
	sprite.texture = item.texture
	yield(get_tree().create_timer(0.7), "timeout")
	dragable = true

func _physics_process(delta):
	velocity += area.get_push_vector() * 0.2
	move_and_collide(velocity)
	velocity = velocity.move_toward(Vector2.ZERO, delta * 5)
