extends CanvasLayer

func _ready():
	pause_mode = Node.PAUSE_MODE_STOP
	yield(get_tree().create_timer(5), "timeout")
	pause_mode = Node.PAUSE_MODE_PROCESS
