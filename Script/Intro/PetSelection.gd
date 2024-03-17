extends Control

onready var marill = $Marill
onready var minccino = $Minccino
onready var turtwig = $Turtwig
onready var ditto = $Ditto

var selection : String = ""
signal pet_selected

func _ready():
	marill.self_modulate = Color(0.5,0.5,0.5,1)
	minccino.self_modulate = Color(0.5,0.5,0.5,1)
	turtwig.self_modulate = Color(0.5,0.5,0.5,1)
	ditto.self_modulate = Color(0.5,0.5,0.5,1)
	
func _on_Minccino_pressed():
	minccino.self_modulate = Color(1,1,1,1)
	marill.self_modulate = Color(0.5,0.5,0.5,1)
	turtwig.self_modulate = Color(0.5,0.5,0.5,1)
	ditto.self_modulate = Color(0.5,0.5,0.5,1)
	selection = "Minccino"
	emit_signal("pet_selected")
	
func _on_Marill_pressed():
	marill.self_modulate = Color(1,1,1,1)
	minccino.self_modulate = Color(0.5,0.5,0.5,1)
	turtwig.self_modulate = Color(0.5,0.5,0.5,1)
	ditto.self_modulate = Color(0.5,0.5,0.5,1)
	selection = "Marill"
	emit_signal("pet_selected")

func _on_Turtwig_pressed():
	turtwig.self_modulate = Color(1,1,1,1)
	marill.self_modulate = Color(0.5,0.5,0.5,1)
	minccino.self_modulate = Color(0.5,0.5,0.5,1)
	ditto.self_modulate = Color(0.5,0.5,0.5,1)
	selection = "Turtwig"
	emit_signal("pet_selected")

func _on_Ditto_pressed():
	ditto.self_modulate = Color(1,1,1,1)
	marill.self_modulate = Color(0.5,0.5,0.5,1)
	minccino.self_modulate = Color(0.5,0.5,0.5,1)
	turtwig.self_modulate = Color(0.5,0.5,0.5,1)
	selection = "Ditto"
	emit_signal("pet_selected")
