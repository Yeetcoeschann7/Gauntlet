extends Area3D

@onready var HUD = get_tree().root.get_node("RandomLevel/player/Camera3D/Hud")
@onready var globs = get_tree().root.get_node("/root/Globs")

func _on_body_entered(body):
	if("player" in body.name):
		call_deferred("change_level")
		
func change_level():
	globs.total_slimes = 0
	get_tree().change_scene_to_file("res://assets/scenes/levels/randomLevel.tscn")
