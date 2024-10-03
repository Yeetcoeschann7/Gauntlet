extends Control

@onready var effect:AudioEffectLowPassFilter = AudioServer.get_bus_effect(AudioServer.get_bus_index("Music"), 0)
@onready var music = AudioServer.get_bus_index("Music")
@onready var sfx = AudioServer.get_bus_index("SFX")
@onready var master = AudioServer.get_bus_index("Master")
@onready var globs = get_tree().root.get_node("/root/Globs")
const NORM_RES = 1
const NORM_CUTOFF = 9999
var sfx_drag = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	effect.cutoff_hz = NORM_CUTOFF
	effect.resonance = NORM_RES
	$menuBG/menuContainer/masterSlider.set("value", db_to_linear(globs.masterVol))
	$menuBG/menuContainer/musicSlider.set("value", db_to_linear(globs.musicVol))
	$menuBG/menuContainer/SFXSlider.set_value_no_signal(db_to_linear(globs.sfxVol))
	$menuBG/menuContainer/masterSlider.grab_focus()

func _on_master_slider_value_changed(value: float) -> void:
	#AudioServer.set_bus_volume_db(master, value)
	AudioServer.set_bus_volume_db(master, linear_to_db(value))

func _on_music_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(music, linear_to_db(value))

func _on_sfx_slider_value_changed(value: float) -> void:
	if $testNoise.playing == false and sfx_drag == false:
		$testNoise.play()
	AudioServer.set_bus_volume_db(sfx, linear_to_db(value))
	
func _on_sfx_slider_drag_started() -> void:
	sfx_drag = true

func _on_sfx_slider_drag_ended(_value_changed: bool) -> void:
	sfx_drag = false
	if $testNoise.playing == false:
		$testNoise.play()

func _on_save_button_pressed() -> void:
	globs.masterVol = AudioServer.get_bus_volume_db(master)
	globs.musicVol = AudioServer.get_bus_volume_db(music)
	globs.sfxVol = AudioServer.get_bus_volume_db(sfx)
	globs.save()

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://assets/scenes/UI/Menus/main_menu.tscn")

func _on_defaults_button_pressed() -> void:
	AudioServer.set_bus_volume_db(master, 0)
	$menuBG/menuContainer/masterSlider.set("value", 1)
	AudioServer.set_bus_volume_db(music, 0)
	$menuBG/menuContainer/musicSlider.set("value", 1)
	AudioServer.set_bus_volume_db(sfx, 0)
	$menuBG/menuContainer/SFXSlider.set_value_no_signal(1)

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://assets/scenes/UI/Menus/main_menu.tscn")
