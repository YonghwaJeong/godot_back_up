extends TextureButton

onready var textureRect = $TextureRect

func _on_TextureRect_mouse_entered():
	textureRect.texture.region = Rect2(0, 58, 74, 58)

func _on_TextureRect_mouse_exited():
	textureRect.texture.region = Rect2(0, 0, 74, 58)
