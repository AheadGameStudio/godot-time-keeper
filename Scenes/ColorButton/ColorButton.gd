extends CenterContainer

onready var color_circle := $ColorRect
onready var label := $Label

const DISABLED = "disabled"
const HOVER = "hover"
const NORMAL = "normal"

var mode = NORMAL

signal button_pressed

func set_text(_val:String):
	label.set_text(_val)
	pass

func change_button_mode(_mode:String):
	match _mode:
		DISABLED:
			color_circle.get_material().set_shader_param("disabled", true)
			$Button.disabled = true
			label.set_modulate(Color(0.3,0.3,0.3))
			mode = DISABLED
		NORMAL:
			color_circle.get_material().set_shader_param("disabled", false)
			$Button.disabled = false
			label.set_modulate(Color(.8,.8,.8))
			mode = NORMAL
		HOVER:
			label.set_modulate(Color.white)
			mode = HOVER
			
			
	mode = _mode

func set_amount(_val:float):
	color_circle.get_material().set_shader_param("amount", _val)

func _on_Button_mouse_entered():
	if mode != DISABLED:
		Input.set_custom_mouse_cursor(null, Input.CURSOR_POINTING_HAND)
		$AnimationPlayer.play("hover")
		change_button_mode(HOVER)


func _on_Button_mouse_exited():
	if mode != DISABLED:
		if $AnimationPlayer.current_animation_position > 0:
			$AnimationPlayer.play_backwards("hover")
			change_button_mode(NORMAL)

func _on_Button_pressed():
	if mode != DISABLED:
		$AnimationPlayer.stop()
		$AnimationPlayer.play("hover")
		change_button_mode(HOVER)
		emit_signal("button_pressed")
