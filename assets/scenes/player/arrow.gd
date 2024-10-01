extends Area3D

const SPEED = 5.0

func _ready():
	$woosh.play()

func _physics_process(delta):
	position.y -= delta * 3
	var angle = self.get_rotation().y   
	position += (Vector3(sin(angle),0, cos(angle)) * 10 ) * (delta * SPEED)
	
func _on_body_entered(body):
	if"GridMap" in body.name or "slime" in body.name or "CharacterBody3D" in body.name:
		if "GridMap" not in body.name:
			body.take_damage()
		queue_free()

func _on_area_entered(area):
	if "spawner" in area.name:
		area.get_parent().take_damage()
		queue_free()
