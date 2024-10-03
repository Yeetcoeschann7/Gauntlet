extends Control

@onready var globs = get_tree().root.get_node("/root/Globs")
@onready var effect:AudioEffectLowPassFilter = AudioServer.get_bus_effect(AudioServer.get_bus_index("Music"), 0)
var dead = false
enum {SEVEN_TWENTY, NINE_HUNDRED, TEN_EIGHTY}
var resolution = SEVEN_TWENTY
const NORM_RES = 1
const NORM_CUTOFF = 9999
const MUFFLED_RES = 0.2
const MUFFLED_CUTOFF = 2000

# Called when the node enters the scene tree for the first time.
func _ready():
	effect.cutoff_hz = NORM_CUTOFF
	effect.resonance = NORM_RES
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	$gameOver.visible = false
	$pause.visible = false
	$ColorRect.visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$ColorRect/healthBar.value = globs.player_health
	$ColorRect/healthBar/heathLabel.text = var_to_str(roundi($ColorRect/healthBar.value))
	$ColorRect/hiScore/hiScoreValue.text = var_to_str(int(globs.highscore))
	$ColorRect/Score/scoreValue.text = var_to_str(globs.score)
	if get_tree().paused != true:
		$ColorRect/Timer/timeLeft.text = var_to_str(roundi(get_tree().root.get_node("RandomLevel/floorTime").time_left))
		if roundi(get_tree().root.get_node("RandomLevel/floorTime").time_left) <= 10:
			$ColorRect/Timer/timeLeft.set("theme_override_colors/font_color", Color(1,0,0))
		else:
			$ColorRect/Timer/timeLeft.set("theme_override_colors/font_color", Color(1,1,1))
	if Input.is_action_just_pressed("pause") and $gameOver.visible == false and get_tree().paused == false:
		effect.cutoff_hz = MUFFLED_CUTOFF
		effect.resonance = MUFFLED_RES
		$pause.visible = true
		$pause/resume.visible = true
		get_tree().paused = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		$pause/resume.grab_focus()
		
func game_over():
	effect.cutoff_hz = MUFFLED_CUTOFF
	effect.resonance = MUFFLED_RES
	if globs.score > globs.highscore:
		globs.highscore = globs.score
	$gameOver.visible = true
	$gameOver/retry.visible = true
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	globs.save()
	$gameOver/retry.grab_focus()

func _on_quit_pressed():
	get_tree().quit()

func _on_resume_pressed():
	effect.cutoff_hz = NORM_CUTOFF
	effect.resonance = NORM_RES
	get_tree().paused = false
	$pause.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _on_retry_pressed():
	effect.cutoff_hz = NORM_CUTOFF
	effect.resonance = NORM_RES
	get_tree().paused = false
	$gameOver.visible = false
	globs.total_slimes = 0
	globs.player_health = 90
	globs.score = 0
	globs.floor_num = 0
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	get_tree().change_scene_to_file("res://assets/scenes/levels/randomLevel.tscn")
	
func _on_h_slider_value_changed(value):
	get_viewport().set_scaling_3d_scale(value)
