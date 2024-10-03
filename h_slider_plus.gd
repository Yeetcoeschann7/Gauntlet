extends HSlider
class_name HSliderPlus

@onready var globs = get_tree().root.get_node("/root/Globs")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	focus_exited.connect(func(): globs.button_focus_moved())
	value_changed.connect(func(_value): globs.button_focus_moved())
	mouse_entered.connect(func(): grab_focus())
