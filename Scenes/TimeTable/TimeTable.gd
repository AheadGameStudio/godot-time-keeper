extends MarginContainer

export(Color) var active_line_color:Color = Color.aqua

var _cell_line_scene:PackedScene
var _current_line:int = 0 setget set_current_line, get_current_line

const _adjust_time = 24*60*60
onready var table_container := $VBoxContainer/ScrollContainer/VBoxContainer
onready var scroll_container := $VBoxContainer/ScrollContainer
onready var empty_box := $VBoxContainer/EmptyBox
onready var cell_header := $VBoxContainer/CellHeader

func _ready():
	_cell_line_scene = load("res://Scenes/CellLine/CellLine.tscn")
	# warning-ignore:return_value_discarded
	Global.connect("set_time_table", self, "_on_time_table_added")
	
	empty_box.set_visible(true)
	scroll_container.set_visible(false)
	cell_header.set_visible(false)

func _on_time_table_added():
	print("タイムテーブルコンテナがタイムテーブルの読み込みを検知しました")
	
	empty_box.set_visible(false)
	scroll_container.set_visible(true)
	cell_header.set_visible(true)
	
	var _arr:Array = Global.get_time_table()
	
	clear()
	
	for i in _arr:
		append([ i[0], i[1], i[3] ])
	
	activate_line(get_current_line())

func append(_arr):
	var _ins = _cell_line_scene.instance()
	table_container.add_child(_ins)
	_ins.set_values(_arr)
	_ins.set_font_color(Color.black)

func clear():
	for _c in table_container.get_children():
		table_container.remove_child(_c)

func get_current_line():
	return _current_line

func set_current_line(_line):
	_current_line = _line
	activate_line(_line)
	
func get_line_value(_line, _num):
	var _child = table_container.get_child(_line)
	
	return _child.get_value(_num)
	
func get_current_line_time(is_start_time:bool = true):	
	var _str:String = get_line_value(get_current_line(), int(!is_start_time))
	var _dic = convert_time_dict_from_string(_str)
	
	var _adjust = 0
	if _dic["hour"] == 0 and !is_start_time:
		_adjust = _adjust_time	 
	var _unix = OS.get_unix_time_from_datetime(_dic) + _adjust
	return OS.get_datetime_from_unix_time(_unix)
	
func convert_time_dict_from_string(_str:String, _adjust:bool = false):
	var _arr = _str.split(":")
	var _current_date:Dictionary = Global.get_execute_date().duplicate()
	
	var _adjust_time = 0
	if _adjust:
		_adjust_time = 1
	_current_date["day"] = String(int(_current_date["day"]) + 1 * _adjust_time) 
	var _dict = Global.merge_dict(_current_date, {"hour": int(_arr[0]), "minute": int(_arr[1]), "second": 0} )
	return _dict

func get_table_length():
	return Global.get_time_table().size()
	
func activate_line(_line):
	for i in range(table_container.get_child_count()):
		var _child = table_container.get_child(i)
#		print(_child.name)
		if i == _line:
			_child.set_modulate(Color(0.3,1,1))
		else:
			_child.set_modulate(Color.white)
