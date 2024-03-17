extends TextureButton

func _on_CharacterSetting_enable_OK():
	disabled = false
	modulate = Color(1,1,1,1)

func _on_CharacterSetting_disable_OK():
	disabled = true
	modulate = Color("9a9a9a")
