extends Label

var current_skin = 1

func _on_Skin_Next_pressed():
	current_skin += 1
	if current_skin > 25:
		current_skin = 1
	text = "%d" %current_skin

func _on_Skin_Previous_pressed():
	current_skin -= 1
	if current_skin < 1:
		current_skin = 25
	text = "%d" %current_skin
