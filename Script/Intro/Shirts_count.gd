extends Label

func _on_PlayerAppearance_shirts_changed(current_shirts):
	text = "%d" %(current_shirts+1)
