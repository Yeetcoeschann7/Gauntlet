extends Node
enum{WINDOWED, MINIMIZED, MAXIMIZED, FULLSCREEN}
var total_slimes = 0
var player_health = 90
var highscore = 0
var score = 0
var floor_num = 0

# Options
var resScale = 1
var brightScale = 1.1
var contrastScale = 1.1
var saturationScale = 1.1
var shadows = true
var screenMode = DisplayServer.WINDOW_MODE_MAXIMIZED
var masterVol = 1
var musicVol = 1
var sfxVol = 1

@onready var select_noise = AudioStreamPlayer.new()
@onready var click_noise = AudioStreamPlayer.new()

func _ready():
	loadSave()
	select_noise.stream = load("res://assets/audio/sfx/select.wav")
	click_noise.stream = load("res://assets/audio/sfx/click.wav")
	select_noise.bus = "SFX"
	click_noise.bus = "SFX"
	add_child(select_noise)
	add_child(click_noise)
		
func save():
	var save_file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	var save_dict = {
		"highscore" : highscore,
		"brightness" : brightScale,
		"contrast" : contrastScale,
		"saturation" : saturationScale,
		"shadows" : shadows,
		"screenMode" : screenMode,
		"masterVol" : masterVol,
		"musicVol" : musicVol,
		"sfxVol" : sfxVol
		}
	var json_string = JSON.stringify(save_dict)
	save_file.store_line(json_string)
	
func loadSave():
	if not FileAccess.file_exists("user://savegame.save"):
		return
	var save_file = FileAccess.open("user://savegame.save", FileAccess.READ)
	var json_string = ""
	while save_file.get_position() < save_file.get_length():
		json_string += save_file.get_line()
	var save_dict = JSON.parse_string(json_string)
	highscore = save_dict["highscore"]
	brightScale = save_dict["brightness"]
	contrastScale = save_dict["contrast"]
	saturationScale = save_dict["saturation"]
	shadows = save_dict["shadows"]
	screenMode = save_dict["screenMode"]
	masterVol = save_dict["masterVol"]
	musicVol = save_dict["musicVol"]
	sfxVol = save_dict["sfxVol"]
	DisplayServer.window_set_mode(screenMode)
	
func button_focus_moved():
	select_noise.play()
	
func button_clicked():
	click_noise.play()
	
func _input(event) -> void:
	if Input.is_anything_pressed() and event is not InputEventMouseButton:
		Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
	if event is InputEventMouseMotion:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
