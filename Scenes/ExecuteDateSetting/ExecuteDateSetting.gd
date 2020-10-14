extends "res://Assets/Scripts/BlurRect.gd"

signal accept_date

onready var exe_year_box := $PanelContainer/CenterContainer/VBoxContainer/HBoxContainer/Year
onready var exe_month_box := $PanelContainer/CenterContainer/VBoxContainer/HBoxContainer/Month
onready var exe_day_box := $PanelContainer/CenterContainer/VBoxContainer/HBoxContainer/Day

func _on_Set_Date_Accept_Button_pressed():
	# 日本時間を取得
	var _now = Global.get_japan_time(OS.get_unix_time())
	
	var _year
	var _month
	var _day
	
	_year = exe_year_box.get_text()
	if exe_year_box.get_text() == "":
		_year = _now["year"]
	
	_month = exe_month_box.get_text()
	if exe_month_box.get_text() == "":
		_month = _now["month"]
	
	_day = exe_day_box.get_text()
	if exe_day_box.get_text() == "":
		_day = _now["day"]
	
	var _dict:Dictionary = {"year": _year, "month": _month, "day": _day}
	
	emit_signal("accept_date", _dict)
	_close()

func _close():
	queue_free()
