extends TextureButton

onready var textureRect = $TextureRect

func _on_TextureRect_mouse_entered():
	textureRect.texture.region = Rect2(296, 65+27, 66, 27)

func _on_TextureRect_mouse_exited():
	textureRect.texture.region = Rect2(296, 65, 66, 27)
