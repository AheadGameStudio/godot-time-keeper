extends PanelContainer

# warning-ignore:unused_argument
func _ready():
	var _mouse_pos := get_global_mouse_position()
	set_position(_mouse_pos + Vector2(16, 8))

func _input(event):
	if event is InputEventMouseMotion:
		var _mouse_pos = event.position
		set_position(_mouse_pos + Vector2(16, 8))
	
func active(_text = ""):
	$MarginContainer/Label.set_text(_text)
