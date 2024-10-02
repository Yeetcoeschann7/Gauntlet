extends Node
enum{WINDOWED, MINIMIZED, MAXIMIZED, FULLSCREEN}
var total_slimes = 0
var player_health = 90
var highscore = 0
var score = 0
var floor_num = 0

func _ready():
	loadSave()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func _input(_event):
	if Input.is_action_just_pressed("fullscreen"):
			toggle_fullscreen()
			
func toggle_fullscreen():
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_MAXIMIZED:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
		
func save():
	var save_file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	var save_dict = {"highscore" : highscore}
	var json_string = JSON.stringify(save_dict)
	save_file.store_line(json_string)
	
func loadSave():
	if not FileAccess.file_exists("user://savegame.save"):
		return
	var save_file = FileAccess.open("user://savegame.save", FileAccess.READ)
	var json_string = save_file.get_line()
	var save_dict = JSON.parse_string(json_string)
	highscore = save_dict["highscore"]
