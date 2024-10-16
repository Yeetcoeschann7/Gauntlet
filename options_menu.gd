extends Control

@onready var globs = get_tree().root.get_node("/root/Globs")
@onready var screenMode = globs.screenMode

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$menuBG/menuContainer/ResSlider.grab_focus()
	match(int(globs.screenMode)):
		2:#Maximized
			$menuBG/menuContainer/screenDropdown.select(0)
		3:#Fullscreen
			$menuBG/menuContainer/screenDropdown.select(1)
	$menuBG/menuContainer/ResSlider.value = globs.resScale
	$menuBG/menuContainer/brightnessSlider.value = globs.brightScale
	$menuBG/menuContainer/contrastSlider.value = globs.contrastScale
	$menuBG/menuContainer/saturationSlider.value = globs.saturationScale
	$menuBG/menuContainer/shadowBox.button_pressed = globs.shadows
	$menuBG/menuContainer/AABox.button_pressed = globs.AA

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://assets/scenes/UI/Menus/main_menu.tscn")

func _on_res_slider_value_changed(value: float) -> void:
	$menuBG/previewContainer/previewViewport.set_scaling_3d_scale(value)

func _on_brightness_slider_value_changed(value: float) -> void:
	$menuBG/previewContainer/previewViewport/Node3D/Camera3D.environment.set_adjustment_brightness(value)

func _on_contrast_slider_value_changed(value: float) -> void:
	$menuBG/previewContainer/previewViewport/Node3D/Camera3D.environment.set_adjustment_contrast(value)
	
func _on_saturation_slider_value_changed(value: float) -> void:
	$menuBG/previewContainer/previewViewport/Node3D/Camera3D.environment.set_adjustment_saturation(value)

func _on_screen_dropdown_item_selected(index: int) -> void:
	match(index):
		0:
			screenMode = DisplayServer.WINDOW_MODE_MAXIMIZED
		1:
			screenMode = DisplayServer.WINDOW_MODE_FULLSCREEN

func _on_shadow_box_toggled(toggled_on: bool) -> void:
	$menuBG/previewContainer/previewViewport/Node3D/DirectionalLight3D.shadow_enabled = toggled_on

func _on_aa_box_toggled(toggled_on: bool) -> void:
	if toggled_on == true:
		$menuBG/previewContainer/previewViewport.msaa_3d = Viewport.MSAA_2X
	else:
		$menuBG/previewContainer/previewViewport.msaa_3d = Viewport.MSAA_DISABLED

func _on_save_button_pressed() -> void:
	globs.resScale = $menuBG/menuContainer/ResSlider.value
	globs.screenMode = screenMode
	globs.brightScale = $menuBG/menuContainer/brightnessSlider.value
	globs.contrastScale = $menuBG/menuContainer/contrastSlider.value
	globs.saturationScale = $menuBG/menuContainer/saturationSlider.value
	globs.shadows = $menuBG/menuContainer/shadowBox.button_pressed
	globs.AA = $menuBG/menuContainer/AABox.button_pressed
	DisplayServer.window_set_mode(globs.screenMode)
	globs.save()

func _on_defaults_button_pressed() -> void:
	_on_res_slider_value_changed(1)
	$menuBG/menuContainer/ResSlider.value = 1
	_on_brightness_slider_value_changed(1.1)
	$menuBG/menuContainer/brightnessSlider.value = 1.1
	_on_contrast_slider_value_changed(1.1)
	$menuBG/menuContainer/contrastSlider.value = 1.1
	_on_saturation_slider_value_changed(1.1)
	$menuBG/menuContainer/saturationSlider.value = 1.1
	$menuBG/menuContainer/shadowBox.button_pressed = true
	$menuBG/previewContainer/previewViewport/Node3D/DirectionalLight3D.shadow_enabled = true
	$menuBG/menuContainer/AABox.button_pressed = true
	$menuBG/previewContainer/previewViewport.screen_space_aa = Viewport.SCREEN_SPACE_AA_FXAA

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://assets/scenes/UI/Menus/main_menu.tscn")
