extends MeshInstance3D

@onready var SLIME = preload("res://assets/scenes/enemies/slime.tscn")
@onready var globs = get_tree().root.get_node("/root/Globs")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_timer_timeout():
	if globs.total_slimes < 20:
		globs.total_slimes += 1
		var enemy = SLIME.instantiate()
		get_tree().root.get_node("mainLevel").add_child(enemy)
		enemy.global_transform = global_transform
		enemy.set_scale(Vector3(5,5,5))
		$Timer.wait_time = randi_range(3,10)
