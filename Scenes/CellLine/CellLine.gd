extends HBoxContainer

export(Color) var font_color:Color = Color.white
export(StyleBox) var panel_theme

var _panels:Array
var _labels:Array

func _ready():
	_panels.append(get_node("PanelContainer"))
	_panels.append(get_node("PanelContainer2"))
	_panels.append(get_node("PanelContainer3"))
	
	if panel_theme != null:
		for _panel in _panels:
			_panel.set("custom_styles/panel", panel_theme)
	
	_labels.append(get_node("PanelContainer/MarginContainer/Label"))
	_labels.append(get_node("PanelContainer2/MarginContainer/Label"))
	_labels.append(get_node("PanelContainer3/MarginContainer/Label"))
	
	set_font_color(font_color)

func set_values(_arr:Array):
#	print(_arr)
	for i in range(_arr.size()):
#		prints(i, _arr[i])
		_labels[i].set_text(_arr[i])

func get_value(_num):
	return _labels[_num].get_text()

func set_font_color(_color:Color):
	for _label in _labels:
		_label.set("custom_colors/font_color", _color)
