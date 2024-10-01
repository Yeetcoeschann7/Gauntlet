extends Control

@onready var globs = get_tree().root.get_node("/root/Globs")
var dead = false

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	$gameOver.visible = false
	$pause.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$healthBar.value = globs.player_health
	$hiScore/hiScoreValue.text = var_to_str(int(globs.highscore))
	$Score/scoreValue.text = var_to_str(globs.score)
	if get_tree().paused != true:
		$Timer/timeLeft.text = var_to_str(roundi(get_tree().root.get_node("RandomLevel/floorTime").time_left))
		if roundi(get_tree().root.get_node("RandomLevel/floorTime").time_left) <= 10:
			$Timer/timeLeft.set("theme_override_colors/font_color", Color(1,0,0))
		else:
			$Timer/timeLeft.set("theme_override_colors/font_color", Color(1,1,1))
	if Input.is_action_just_pressed("pause") and $gameOver.visible == false and get_tree().paused == false:
		$pause/Score/scoreValue.text = $Score/scoreValue.text
		$pause.visible = true
		$pause/Score.visible = false
		$pause/resume.visible = true
		get_tree().paused = true
		$pause/resume.grab_focus()
		
func game_over():
	if globs.score > globs.highscore:
		globs.highscore = globs.score
	$gameOver/Score/scoreValue.text = $Score/scoreValue.text
	$gameOver.visible = true
	$gameOver/Score.visible = true
	$gameOver/retry.visible = true
	get_tree().paused = true
	globs.save()
	$gameOver/retry.grab_focus()

func _on_quit_pressed():
	get_tree().quit()

func _on_resume_pressed():
	get_tree().paused = false
	$pause.visible = false

func _on_retry_pressed():
	get_tree().paused = false
	$gameOver.visible = false
	globs.total_slimes = 0
	globs.player_health = 90
	globs.score = 0
	globs.floor_num = 0
	get_tree().change_scene_to_file("res://assets/scenes/levels/randomLevel.tscn")
