extends LineEdit

func _ready():
	connect("focus_entered", self, "delete_placeholder")
	
func delete_placeholder():
	placeholder_text = ""
	
