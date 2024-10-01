extends Control

@onready var globs = get_tree().root.get_node("/root/Globs")
var dead = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$gameOver.visible = false
	$pause.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$healthBar.value = globs.player_health
	$Score/scoreValue.text = var_to_str(globs.score)
	$hiScore/hiScoreValue.text = var_to_str(globs.highscore)
	if get_tree().paused != true:
		$Timer/timeLeft.text = var_to_str(roundi(get_tree().root.get_node("RandomLevel/floorTime").time_left))
	if Input.is_action_just_pressed("pause") and $gameOver.visible == false:
		$pause/Score/scoreValue.text = $Score/scoreValue.text
		$pause.visible = true
		$pause/Score.visible = false
		$pause/resume.visible = true
		get_tree().paused = true
		$pause/resume.grab_focus()
		
func game_over():
	$gameOver/Score/scoreValue.text = $Score/scoreValue.text
	$gameOver.visible = true
	$gameOver/Score.visible = true
	$gameOver/retry.visible = true
	get_tree().paused = true
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
	get_tree().change_scene_to_file("res://assets/scenes/levels/randomLevel.tscn")
