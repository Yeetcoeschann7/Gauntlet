extends Area3D

@onready var HUD = get_tree().root.get_node("RandomLevel/player/Camera3D/Hud")
@onready var globs = get_tree().root.get_node("/root/Globs")
@onready var time = get_tree().root.get_node("RandomLevel/floorTime")

func _on_body_entered(body):
	if("player" in body.name):
		globs.score += 300
		var tempTime = clamp(time.time_left + 1, 0 , 30)
		time.start(tempTime)
		var goldSound = $goldNoise
		$goldNoise.play()
		remove_child(goldSound)
		get_parent().add_child(goldSound)
		call_deferred("queue_free")
		
func _process(delta):
	$MeshInstance3D.rotation_degrees.z += delta * 150
