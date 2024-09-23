extends Control

var dead = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$gameOver.visible = false
	$pause.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if get_tree().paused == true:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)
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
	get_tree().change_scene_to_file("res://assets/scenes/levels/main_level.tscn")
