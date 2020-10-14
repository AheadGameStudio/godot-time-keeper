extends ColorRect

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		queue_free()
