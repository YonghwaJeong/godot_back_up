extends TextureButton

func _ready():
	material.set_shader_param("original_color", Color(0, 0.5, 0.5, 1))
