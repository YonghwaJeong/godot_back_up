extends Area2D

func _on_Collecting_body_entered(body):
	body.queue_free()
