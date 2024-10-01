extends Area3D

func _on_body_entered(body):
	if("player" in body.name):
		body.heal()
		queue_free()
