extends Node3D

const dir = [Vector2.RIGHT, Vector2.LEFT, Vector2.UP, Vector2.DOWN]
@onready var globs = get_tree().root.get_node("/root/Globs")
@onready var SPAWNER = preload("res://assets/scenes/enemies/spawner.tscn")
@onready var FOOD = preload("res://assets/scenes/items/food.tscn")
@onready var GOLD = preload("res://assets/scenes/items/gold.tscn")
@onready var DOOR = preload("res://assets/scenes/items/door.tscn")
@onready var HUD = get_tree().root.get_node("RandomLevel/player/Camera3D/Hud")

var grid_size = 16
var grid_steps = 700
var spawner_count = 0
var food_count = 0
var gold_count = 0
var doAlarm = true
var usedPositions = [Vector2(0,0)]

func _ready():
	get_viewport().set_scaling_3d_scale(globs.resScale)
	$player/Camera3D.environment.set_adjustment_brightness(globs.brightScale)
	$player/Camera3D.environment.set_adjustment_contrast(globs.contrastScale)
	$player/Camera3D.environment.set_adjustment_saturation(globs.saturationScale)
	$DirectionalLight3D.shadow_enabled = globs.shadows
	if globs.AA:
		get_viewport().msaa_3d = Viewport.MSAA_2X
	else:
		get_viewport().msaa_3d = Viewport.MSAA_DISABLED
	DisplayServer.window_set_mode(globs.screenMode)
	randomize()
	var current_pos = Vector2(0,0)
	
	var current_dir = Vector2.RIGHT
	$GridMap.set_cell_item(Vector3i(0,0,0), 5, 0)
	var last_dir = current_dir * -1
	var j = 0.0
	var k = 0.0
	var l = 0.0
	
	for i in range (0, grid_steps):
		j += 1
		k += 1
		l += 1
		var temp_dir = dir.duplicate()
		temp_dir.shuffle()
		var d = temp_dir.pop_front()
		
		while (abs(current_pos.x + d.x) > grid_size or abs(current_pos.y +d.y) > grid_size):
			temp_dir.shuffle()
			d = temp_dir.pop_front()
		
		current_pos += d
		last_dir = d  
		
		# Place 3D mesh
		$GridMap.set_cell_item(Vector3i(current_pos.x,0,current_pos.y), 5, 0)
		var doSpawner = randi_range(0,500)
		var doGold = randi_range(0,500)
		var doFood = randi_range(0,500)
		if doSpawner <= j/10 and spawner_count < 8 and not i >= grid_steps - 1 and not Vector2(current_pos.x, current_pos.y) in usedPositions:
			var spawner = SPAWNER.instantiate()
			get_tree().root.get_node("RandomLevel").add_child(spawner)
			spawner.global_position = Vector3((current_pos.x * 10) + 5, 0, (current_pos.y * 10) + 5)
			spawner_count += 1
			usedPositions.append(Vector2(current_pos.x, current_pos.y))
			j = 0
		elif doGold < k/10 and gold_count < 10 and not Vector2(current_pos.x, current_pos.y) in usedPositions:
			var gold = GOLD.instantiate()
			get_tree().root.get_node("RandomLevel").add_child(gold)
			gold.global_position = Vector3((current_pos.x * 10) + 5, 0, (current_pos.y * 10) + 5)
			gold_count += 1
			usedPositions.append(Vector2(current_pos.x, current_pos.y))
			k = 0
		elif doFood < l/50 and food_count < 1 and not Vector2(current_pos.x, current_pos.y) in usedPositions:
			var food = FOOD.instantiate()
			get_tree().root.get_node("RandomLevel").add_child(food)
			food.global_position = Vector3((current_pos.x * 10) + 5, 0, (current_pos.y * 10) + 5)
			food_count += 1
			usedPositions.append(Vector2(current_pos.x, current_pos.y))
			l = 0
	var door = DOOR.instantiate()
	get_tree().root.get_node("RandomLevel").add_child(door)
	door.global_position = Vector3((current_pos.x * 10) + 5, 0, (current_pos.y * 10) + 5)
	$GridMap.set_cell_item(Vector3i(current_pos.x,0,current_pos.y), 5, 0)
	$GridMap.set_cell_item(Vector3i(current_pos.x,-1,current_pos.y), 5, 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if $floorTime.time_left <= 10:
		if doAlarm == true:
			$timeAlarm.play()
			doAlarm = false
	else:
		doAlarm = true

func _on_floor_time_timeout():
	HUD.game_over()
