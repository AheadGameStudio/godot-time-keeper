extends MarginContainer

onready var button := $PanelContainer
onready var label := $PanelContainer/MarginContainer/Label

const DISABLED = "disabled"
const HOVER = "hover"
const NORMAL = "normal"

var mode = NORMAL

signal button_pressed

func change_button_color(_color1:Color, _color2:Color, _font_color:Color):
	button.get_material().set_shader_param("color1", _color1)
	button.get_material().set_shader_param("color2", _color2)
	label.set("custom_colors/font_color", _font_color)

func change_button_mode(_mode:String):
	match _mode:
		DISABLED:
			var _dark = Color(0.4,0.4,0.4)
			label.set_self_modulate(_dark)
			button.set_self_modulate(_dark)
		HOVER:
			label.set_self_modulate(Color(1.2,1.2,1.2,0.9))
			button.set_self_modulate(Color(1.2,1.2,1.2,1))
		NORMAL:
			label.set_self_modulate(Color(1,1,1,1))
			button.set_self_modulate(Color(1,1,1,1))
			
	mode = _mode


func _on_Button_mouse_entered():
	if mode != DISABLED:
		change_button_mode(HOVER)


func _on_Button_mouse_exited():
	if mode != DISABLED:
		change_button_mode(NORMAL)

func _on_Button_pressed():
	if mode != DISABLED:
		emit_signal("button_pressed")
