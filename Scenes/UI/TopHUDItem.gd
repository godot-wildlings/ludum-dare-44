extends Label

# Declare member variables here. Examples:
export var tool_tip : String

# Called when the node enters the scene tree for the first time.
func _ready():
	mouse_filter = Control.MOUSE_FILTER_PASS
	set_tooltip(tool_tip)

