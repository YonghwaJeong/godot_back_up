extends Area2D

func _ready():
	connect("area_entered", self, "_on_WateredArea_area_entered")

func _on_WateredArea_area_entered(area):
	area.get_parent().is_watered = true
