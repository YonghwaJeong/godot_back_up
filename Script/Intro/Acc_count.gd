extends Label

func _on_PlayerAppearance_acc_changed(current_acc):
	if current_acc == 19:
		text = "Empty"
	else:
		text = "%d" %(current_acc+1)
