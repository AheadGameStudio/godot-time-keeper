extends Control

onready var close_confirm := $CloseConfirm
onready var execute_date_setting := $ExecuteDateSetting
onready var load_dialog := $LoadDialog
onready var file_dialog := $LoadDialog/FileDialog
onready var time_table := $Container/TimeTable
onready var control_button := $Container/ControlButton
onready var message_window := $Container/MessageWindow
onready var current_sequence := $Container/CurrentSequence
onready var tooltip:PackedScene = preload("res://Scenes/Tooltip/Tooltip.tscn")

var _tooltip_ins
var _prev_mouse_position:Vector2

var time_table_array:Array

func _ready():
	check_execute()
	
	close_confirm.set_visible(false)
	execute_date_setting.set_visible(false)
# warning-ignore:return_value_discarded
	file_dialog.connect("file_selected", self, "_on_TimeTable_selected")
# warning-ignore:return_value_discarded
	file_dialog.connect("popup_hide", self, "_on_Load_TimeTable_Dialog_close")
	
	### SET DEFAULT SETTING
	control_button.change_button_mode(control_button.DISABLED)
	message_window.set_visible(true)
	current_sequence.set_visible(false)
	
	
# warning-ignore:unused_argument
func _process(delta):
	_prev_mouse_position = get_global_mouse_position()

func _on_close_button_pressed():
	close_confirm.set_visible(true)

func _on_close_accept_cutton_pressed():
	get_tree().quit()

func _on_close_cancel_button_pressed():
	close_confirm.set_visible(false)

func _on_Set_Execute_Date_Button_mouse_entered():
	_tooltip_ins = tooltip.instance()
	_tooltip_ins.active("実行する日程を設定")
	add_child(_tooltip_ins)

func _on_Button_mouse_exited():
	_tooltip_ins.queue_free()

func _on_Load_TimeTable_Button_mouse_entered():
	_tooltip_ins = tooltip.instance()
	_tooltip_ins.active("タイムテーブルを読み込む")
	add_child(_tooltip_ins)

func _on_Set_Execute_Date_Button_pressed():
	execute_date_setting.set_visible(true)

func _on_Set_Date_Cancel_Button_pressed():
	execute_date_setting.set_visible(false)
	
onready var exe_year_box := $ExecuteDateSetting/PanelContainer/CenterContainer/VBoxContainer/HBoxContainer/Year
onready var exe_month_box := $ExecuteDateSetting/PanelContainer/CenterContainer/VBoxContainer/HBoxContainer/Month
onready var exe_day_box := $ExecuteDateSetting/PanelContainer/CenterContainer/VBoxContainer/HBoxContainer/Day

func _on_Set_Date_Accept_Button_pressed():
	execute_date_setting.set_visible(false)
	
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
	
	Global.execute_date = {"year": _year, "month": _month, "day": _day}
	prints("日付が設定されました", Global.execute_date)
	check_execute()
	
func check_execute():
	if time_table_array.empty():
		print("タイムラインが読まれてない")
		message_window.set_text("タイムテーブルを読み込んでください")
		return 1
		
	if Global.execute_date.empty():
		print("日付が設定されてない")
		message_window.set_text("実行する日付を設定してください")
		return 2
	
	var _start_time = time_table.get_current_seq_time(true)
		
	while true:
		var _dic = {}
		Global.merge_dict(_dic, _start_time)
		Global.merge_dict(_dic, Global.execute_date)
		var _start_dic = Global.convert_second_to_dict(OS.get_unix_time_from_datetime(_dic) - (OS.get_unix_time() + Global.JAPAN_UTC_TIME))
		message_window.set_text("開始まで%s時間%s分%s秒です" % [_start_dic["hour"], _start_dic["minute"], _start_dic["second"]])
		yield(get_tree().create_timer(30.0), "timeout")
		
	control_button.change_button_mode(control_button.NORMAL)

func _on_Load_TimeTable_Button_pressed():
	load_dialog.set_visible(true)
	file_dialog.popup()

func _on_Load_TimeTable_Dialog_close():
	load_dialog.set_visible(false)
	
func _on_TimeTable_selected(_path):
	if not time_table_array.empty():
		time_table_array.clear()
		time_table.clear()
		
	time_table_array = Global.file_to_array(_path, 1)
	
	for _arr in time_table_array:
		time_table.append([ _arr[0], _arr[1], _arr[3] ])
		
	time_table.set_current_time(0)
	
#	print("Time-table is loaded")
	
	if check_execute() == 2:
		# warning-ignore:return_value_discarded
		message_window.connect("finish_text", self, "_on_Set_Execute_Date_Button_pressed", [], CONNECT_ONESHOT)
		
		current_sequence.set_visible(true)
		current_sequence.set_text(time_table_array[0][3])
	

func _on_ControlButton_button_pressed():
	print("execute button pressed")
