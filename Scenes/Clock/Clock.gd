extends MarginContainer

onready var _date_box := $VBoxContainer/Date
onready var _hours_box := $VBoxContainer/CenterContainer/HBoxContainer/Hours
onready var _seconds_box := $VBoxContainer/CenterContainer/HBoxContainer/MarginContainer/Seconds


# warning-ignore:unused_argument
func _process(delta):
	var _time = Global.get_japan_time(OS.get_unix_time())
	_date_box.set_text("%02d/%02d/%02d" % [_time["year"], _time["month"], _time["day"]])
	_hours_box.set_text("%02d:%02d" % [_time["hour"], _time["minute"]])
	_seconds_box.set_text("%02d" % [_time["second"]])
	
