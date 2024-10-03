extends OptionButton
class_name OptionButtonPlus

@onready var globs = get_tree().root.get_node("/root/Globs")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	focus_exited.connect(func(): globs.button_focus_moved())
	mouse_entered.connect(func(): grab_focus())
	item_selected.connect(func(_index): globs.button_clicked())
	button_down.connect(func(): globs.button_clicked())
