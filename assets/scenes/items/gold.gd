extends Area3D

@onready var HUD = get_tree().root.get_node("RandomLevel/player/Camera3D/Hud")
@onready var globs = get_tree().root.get_node("/root/Globs")

func _on_body_entered(body):
	if("player" in body.name):
		globs.score += 500
		queue_free()
