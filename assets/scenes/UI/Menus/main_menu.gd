extends Control

@onready var globs = get_tree().root.get_node("/root/Globs")
@onready var effect:AudioEffectLowPassFilter = AudioServer.get_bus_effect(AudioServer.get_bus_index("Music"), 0)
const MUFFLED_RES = 0.2
const MUFFLED_CUTOFF = 2000

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	effect.cutoff_hz = MUFFLED_CUTOFF
	effect.resonance = MUFFLED_RES
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$menuBG/menuContainer/playButton.grab_focus()

func _on_quit_button_pressed() -> void:
	globs.save()
	get_tree().quit()

func _on_play_button_pressed() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	get_tree().change_scene_to_file("res://assets/scenes/levels/randomLevel.tscn")

func _on_options_button_pressed() -> void:
	get_tree().change_scene_to_file("res://options_menu.tscn")

func _on_audio_button_pressed() -> void:
	get_tree().change_scene_to_file("res://audio_options.tscn")
