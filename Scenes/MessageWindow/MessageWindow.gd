extends MarginContainer

signal finish_text

func _ready():
	pass

func set_text(_text:String):
	for i in range(_text.length()):
		yield(get_tree().create_timer(0.05), "timeout")
		$PanelContainer/MarginContainer/Label.set_text(_text.left(i+1))
	yield(get_tree().create_timer(1.0), "timeout")
	emit_signal("finish_text")
