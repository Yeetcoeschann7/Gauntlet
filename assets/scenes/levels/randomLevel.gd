extends Node3D

const dir = [Vector2.RIGHT, Vector2.LEFT, Vector2.UP, Vector2.DOWN]
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

func _ready():
	randomize()
	var current_pos = Vector2(0,0)
	
	var current_dir = Vector2.RIGHT
	$GridMap.set_cell_item(Vector3i(0,0,0), 5, 0)
	var last_dir = current_dir * -1
	var j = 0
	var k = 0
	var l = 0
	
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
		if doSpawner <= j/5 and spawner_count < 8:
			var spawner = SPAWNER.instantiate()
			get_tree().root.get_node("RandomLevel").add_child(spawner)
			spawner.global_position = Vector3((current_pos.x * 10) + 5, 0, (current_pos.y * 10) + 5)
			spawner_count += 1
			j = 0
		elif doGold < k/5 and gold_count < 10:
			var gold = GOLD.instantiate()
			get_tree().root.get_node("RandomLevel").add_child(gold)
			gold.global_position = Vector3((current_pos.x * 10) + 5, 0, (current_pos.y * 10) + 5)
			gold_count += 1
			k = 0
		elif doFood < l/5 and food_count < 1:
			var food = FOOD.instantiate()
			get_tree().root.get_node("RandomLevel").add_child(food)
			food.global_position = Vector3((current_pos.x * 10) + 5, 0, (current_pos.y * 10) + 5)
			food_count += 1
			l = 0
	var door = DOOR.instantiate()
	get_tree().root.get_node("RandomLevel").add_child(door)
	door.global_position = Vector3((current_pos.x * 10) + 5, 0, (current_pos.y * 10) + 5)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_floor_time_timeout():
	HUD.game_over()
