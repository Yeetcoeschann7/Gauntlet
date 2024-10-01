extends Area3D

@onready var HUD = get_tree().root.get_node("RandomLevel/player/Camera3D/Hud")
@onready var globs = get_tree().root.get_node("/root/Globs")

func _on_body_entered(body):
	if("player" in body.name):
		call_deferred("change_level")
		
func change_level():
	get_tree().paused = true
	$warpSound.play()

func _on_warp_sound_finished():
	get_tree().paused = false
	globs.total_slimes = 0
	globs.floor_num += 1
	globs.score -= 1000
	get_tree().change_scene_to_file("res://assets/scenes/levels/randomLevel.tscn")
