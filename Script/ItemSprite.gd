extends Sprite

var init_grav_factor = 1.5
var grav_acc = 6
var bounce_speed = 0 
var grav_speed = 0
var first_bounce = true

func _physics_process(delta):
	grav_speed += grav_acc * delta * init_grav_factor
	position.y += grav_speed - bounce_speed
	if position.y > 0 and first_bounce == true :
		grav_speed = 0
		bounce_speed = 1
		init_grav_factor = 1
		first_bounce = false
	elif position.y > 0 and first_bounce == false:
		set_physics_process(false)
