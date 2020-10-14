extends "res://Assets/Scripts/BlurRect.gd"

onready var file_dialog := $FileDialog
var _file_path:String
# warning-ignore:unused_signal
signal file_loaded

func _ready():
	file_dialog.popup()
# warning-ignore:return_value_discarded
	file_dialog.connect("popup_hide", self, "_close")
# warning-ignore:return_value_discarded
	file_dialog.connect("file_selected", self, "_on_file_selected")

func _close():
	emit_signal("file_loaded", _file_path)
	queue_free()

func _on_file_selected(_path):
	prints("ファイルが選択されました：", _path)
	_file_path = _path
	_close()
