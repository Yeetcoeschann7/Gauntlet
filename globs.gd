extends Node
enum{WINDOWED, MINIMIZED, MAXIMIZED, FULLSCREEN}
var total_slimes = 0
var player_health = 90
var highscore = 0
var score = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if score > highscore:
		highscore = score
	
func _input(_event):
	if Input.is_action_just_pressed("fullscreen"):
			toggle_fullscreen()
			
func toggle_fullscreen():
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_MAXIMIZED:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
