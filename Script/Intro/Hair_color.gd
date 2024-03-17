extends Control

onready var hue = $Hue_Value
onready var saturation = $Saturation_Value
onready var brightness = $Brightness_Value

var hue_value : float = 0
var saturation_value : float = 57
var brightness_value : float = 72

signal hair_color_changed(hue_value, saturation_value, brightness_value)

func _ready():
	hue.text = "%d" %hue_value
	saturation.text = "%d" %saturation_value
	brightness.text = "%d" %brightness_value
	
func _on_Hue_value_changed(value):
	hue.text = "%d" %value
	hue_value = value 
	emit_signal("hair_color_changed", hue_value/360, saturation_value/100, brightness_value/100)
	
func _on_Saturation_value_changed(value):
	saturation.text = "%d" %value
	saturation_value = value 
	emit_signal("hair_color_changed", hue_value/360, saturation_value/100, brightness_value/100)

func _on_Brightness_value_changed(value):
	brightness.text = "%d" %value
	brightness_value = value 
	emit_signal("hair_color_changed", hue_value/360, saturation_value/100, brightness_value/100)
