extends MeshInstance3D

@onready var SLIME = preload("res://assets/scenes/enemies/slime.tscn")
@onready var globs = get_tree().root.get_node("/root/Globs")
@onready var time = get_tree().root.get_node("RandomLevel/floorTime")
var blocked = false
var health = 9

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()

func _on_timer_timeout():
	spawn()
	
func spawn():
	if $spawnerArea.has_overlapping_bodies():
		var bodies = $spawnerArea.get_overlapping_bodies()
		blocked = false
		for body in bodies:
			if("slime" in body.name or "CharacterBody3D" in body.name):
				blocked = true
	else:
		blocked = false
	if globs.total_slimes < 20 and blocked == false:
		var enemy = SLIME.instantiate()
		get_tree().root.get_child(2).add_child(enemy)
		enemy.global_transform = global_transform
		enemy.set_scale(Vector3(4,4,4))
		$Timer.wait_time = randi_range(3,10)
	else:
		$Timer.wait_time = 1

func take_damage():
	health -= 1
	if health > 0:
		$hitSound.play()
	$AnimationPlayer.play("damage")

func _on_animation_player_animation_finished(anim_name):
	if health <= 0:
		globs.score += 100
		var tempTime = clamp(time.time_left + 2, 0 , 30)
		time.start(tempTime)
		var breakSound = $breakSound
		$breakSound.play()
		remove_child(breakSound)
		get_tree().get_root().get_child(2).add_child(breakSound)
		call_deferred("queue_free")
