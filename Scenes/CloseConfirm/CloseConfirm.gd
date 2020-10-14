extends "res://Assets/Scripts/BlurRect.gd"

func _on_button_pressed(_id):
	match _id:
		0:
			get_tree().quit()
		1:
			queue_free()

