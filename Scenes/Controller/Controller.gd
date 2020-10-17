extends Control

onready var time_table := $Container/TimeTable
onready var control_button := $Container/Control
onready var message_window := $Container/MessageWindow
onready var current_sequence := $Container/CurrentSequence

enum state{
	DONT_HAVE_SETTINGS,
	READY,
	ALREADY_STARTED_EVENT,
	EXECUTING_EVENT,
	ALREADY_FINISHED_EVENT,
	BEFORE_EVENT
}

var _current_state:int = state.DONT_HAVE_SETTINGS


func _ready():
#	Global.check_execute()
	control_button.change_button_mode(control_button.DISABLED)
	control_button.set_text("おやすみなさい")
# warning-ignore:return_value_discarded
	Global.connect("update", self, "_on_global_update")
	

func _on_global_update():
	_check_settings()
	_control_event_state()

func _check_settings():
	if get_state() == state.DONT_HAVE_SETTINGS:
	#	prints(Global.get_execute_date() ,Global.get_time_table() )
		if Global.get_time_table().empty():
			message_window.set_text("タイムテーブルを読み込んでください")
		elif Global.get_execute_date().empty():
			message_window.set_text("実行する日付を設定してください")
		elif !Global.get_time_table().empty() and !Global.get_execute_date().empty():
			set_state(state.READY)

func _generate_ready_count():
	var start_time = time_table.get_current_line_time(true)
	var _compare = Global.compare_times(start_time)
	
	if _compare < 0:
		message_window.set_text("すでに始まっています")
		set_state(state.ALREADY_STARTED_EVENT)
		var finish_time = time_table.get_line_value(time_table.get_table_length() - 1, 1)
		var _finish_compare = Global.compare_times(time_table.convert_time_dict_from_string(finish_time, true))
		prints("finish:", finish_time, " - ", _finish_compare)
		if _finish_compare < 0:
			message_window.set_text("すでに終了したタイムテーブルです")
			set_state(state.ALREADY_FINISHED_EVENT)
	else:
		var _d:Dictionary = Global.convert_second_to_dict(_compare)
		var _h = _d["hour"]
		var _m = _d["minute"]
		var _s = _d["second"]
		var _str:String = ""
		if _h > 0:
			_str = _str + "%s時間" % [_h]
		if _m > 0:
			_str = _str + "%s分" % [_m]
		if _s > 0:
			_str = _str + "%s秒" % [_s] 
		if _str.length() == 0:
			message_window.set_text("開始時刻です")
			set_state(state.ALREADY_STARTED_EVENT)
		else:
			message_window.set_text(_str + "後に開始します", false)

func _control_event_state():
	if get_state() == state.READY:
		while true:
			if get_state() != state.READY:
				break
			var start_time = time_table.get_current_line_time(true)
			var _compare = Global.compare_times(start_time)
			_generate_ready_count()
			yield(get_tree().create_timer(.5), "timeout")
			
	if get_state() == state.ALREADY_STARTED_EVENT:
		print("ALREADY_STARTED_EVENT")
		set_state(state.EXECUTING_EVENT)
		yield(get_tree().create_timer(1), "timeout")
		control_button.change_button_mode(control_button.NORMAL)
		control_button.set_text("次のシーケンス")
	
	if get_state() == state.EXECUTING_EVENT:
		while true:
			if get_state() != state.EXECUTING_EVENT:
				break
			var start_time = time_table.get_current_line_time(true)
			var finish_time = time_table.get_current_line_time(false)
			var _compare = Global.compare_times(finish_time)
			var start_time_unix = OS.get_unix_time_from_datetime(start_time)
			var finish_time_unix = OS.get_unix_time_from_datetime(finish_time)
			var current_time_unix = OS.get_unix_time() + Global.JAPAN_UTC_TIME
			
			var seq_range = finish_time_unix - start_time_unix
			var current_seq_time = start_time_unix - current_time_unix
			var is_wrap = (current_time_unix - start_time_unix)
#			prints("sec_range:", seq_range, "_compare:", _compare)
			if _compare >= 0 and is_wrap >= 0:
				var _amount:float =  abs(float(current_seq_time) / float(seq_range))
				control_button.set_amount(_amount)
				prints("_amout", _amount)
				message_window.set_text("シーケンス終了まで%sです" % [Global.convert_second_to_time_string(abs(_compare))], false)
				yield(get_tree().create_timer(.1), "timeout")
			elif is_wrap < 0:
				message_window.set_text("%s巻きです" % [Global.convert_second_to_time_string(abs(is_wrap))], false)
				yield(get_tree().create_timer(1), "timeout")
			else:
				message_window.set_text("%s押しです" % [Global.convert_second_to_time_string(abs(_compare))], false)
				yield(get_tree().create_timer(1), "timeout")
	if get_state() == state.ALREADY_FINISHED_EVENT:
		control_button.change_button_mode(control_button.DISABLED)
		control_button.set_text("おやすみなさい")
		message_window.set_text("終了しました", false)


func get_state():
	return _current_state
	
func set_state(_val):
	_current_state = _val

func _on_ControlButton_button_pressed():
	print((time_table.get_table_length() - 1) - time_table.get_current_line())
	if (time_table.get_table_length() - 1) - time_table.get_current_line() != 0:
		time_table.set_current_line(time_table.get_current_line() + 1)
	else:
		print("終了")
		set_state(state.ALREADY_FINISHED_EVENT)
		return
	
	control_button.change_button_mode(control_button.DISABLED)
	yield(get_tree().create_timer(.5), "timeout")
	control_button.change_button_mode(control_button.NORMAL)
