extends PanelContainer

export var _tooltip_scene:PackedScene
export var _load_dialog_scene:PackedScene
export var _close_confirm_scene:PackedScene
export var _execute_date_setting_scene:PackedScene

var _tooltip
var _load_dialog
var _close_confirm
var _execute_date_setting

var _attach_node:Node
	
func _ready():
	get_parent().get_tree().set_auto_accept_quit(false)
	if get_parent_control() == null:
		print("親のコントロールノードがありません。")
	else:
		_attach_node = get_node("../../")
		

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		_on_Button_pressed(2)

func _on_Button_pressed(_id):
	if get_parent_control() != null:
		var _ins
		match _id:
			0:
				_ins = _load_dialog_scene.instance()
				_ins.connect("file_loaded", self, "_on_file_loaded", [], CONNECT_ONESHOT)
			1: 
				_ins = _execute_date_setting_scene.instance()
				_ins.connect("accept_date", self, "_on_accept_date", [], CONNECT_ONESHOT)
			2: 
				_ins = _close_confirm_scene.instance()
#		_attach_node.add_child(_ins)
		_attach_node.call_deferred("add_child", _ins)

func _on_file_loaded(_path):
	if _path != "":
		var _arr:Array = Global.file_to_array(_path, 1)
		Global.set_time_table(_arr)
	
func _on_accept_date(_dict):
	Global.set_execute_date(_dict)

func _on_Button_mouse_entered(_id):
	_tooltip = _tooltip_scene.instance()
	var _ins
	var _text
	match _id:
		0: _text = "タイムテーブルを読み込む"
		1: _text = "実行する日付を設定"
	_attach_node.call_deferred("add_child", _tooltip)
	_tooltip.active(_text)

func _on_Button_mouse_exited():
	if is_instance_valid(_tooltip):
		_tooltip.queue_free()
