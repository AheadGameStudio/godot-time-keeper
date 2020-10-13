extends MarginContainer

var _time_table:Array setget set_time_table, get_time_table
var _cell_line_scene:PackedScene
var current_time:int = 0

onready var table_container := $VBoxContainer/ScrollContainer/VBoxContainer
onready var scroll_container := $VBoxContainer/ScrollContainer
onready var empty_box := $VBoxContainer/EmptyBox
onready var cell_header := $VBoxContainer/CellHeader

func _ready():
	_cell_line_scene = load("res://Scenes/CellLine/CellLine.tscn")

# warning-ignore:unused_argument
func _process(delta):
	var _c = table_container.get_child_count()
	if _c > 0:
		empty_box.set_visible(false)
		scroll_container.set_visible(true)
		cell_header.set_visible(true)
	else:
		empty_box.set_visible(true)
		scroll_container.set_visible(false)
		cell_header.set_visible(false)

func append(_arr):
	var _ins = _cell_line_scene.instance()
	table_container.add_child(_ins)
	_ins.set_values(_arr)
	_ins.set_font_color(Color.black)

func clear():
	for _c in table_container.get_children():
		table_container.remove_child(_c)

func set_time_table(_arr):
	pass

func get_time_table():
	return _time_table

func get_current_time():
	return current_time

func set_current_time(_time):
	current_time = _time
	activate_time(_time)
	
func get_line_value(_time, _num):
	var _line = table_container.get_child(_time)
	return _line.get_value(_num)
	
func get_current_seq_time(_start:bool = true):
	var _s 
	if _start:
		_s = 0
	else:
		_s = 1
	
	var _str:String = get_line_value(current_time, _s)
	var _arr = _str.split(":")
	return {"hour": int(_arr[0]), "minute": int(_arr[1]), "second": 0}
	

func activate_time(_time):
	for i in range(table_container.get_child_count()):
		var _child = table_container.get_child(i)
#		print(_child.name)
		if i == _time:
			_child.set_modulate(Color(1,0.5,0.5))
		else:
			_child.set_modulate(Color.white)
