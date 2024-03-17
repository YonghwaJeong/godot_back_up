extends Label

func _on_PlayerAppearance_hair_changed(current_hair):
	text = "%d" %(current_hair+1)
