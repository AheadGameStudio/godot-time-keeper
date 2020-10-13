extends PanelContainer

# warning-ignore:unused_argument
func _process(delta):
	var _mouse_pos := get_global_mouse_position()
	set_position(_mouse_pos + Vector2(16, 8))

func active(_text = ""):
	$MarginContainer/Label.set_text(_text)
	set_visible(true)

func deactive():
	set_visible(false)
