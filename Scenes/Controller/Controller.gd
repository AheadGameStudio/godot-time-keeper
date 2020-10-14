extends Control

onready var time_table := $Container/TimeTable
onready var control_button := $Container/ControlButton
onready var message_window := $Container/MessageWindow
onready var current_sequence := $Container/CurrentSequence

var comfirmed:bool

func _ready():
#	Global.check_execute()
	control_button.change_button_mode(control_button.DISABLED)
# warning-ignore:return_value_discarded
	Global.connect("update", self, "_on_global_update")

func _on_global_update():
	if !comfirmed:
	#	prints(Global.get_execute_date() ,Global.get_time_table() )
		if Global.get_time_table().empty():
			message_window.set_text("タイムテーブルを読み込んでください")
		elif Global.get_execute_date().empty():
			message_window.set_text("実行する日付を設定してください")
		elif !Global.get_time_table().empty() and !Global.get_execute_date().empty():
#			var start_time = time_table.get_current_line_time(0)
#			var _compare = Global.compare_times(start_time)
#			message_window.set_text("開始まで%sです" % [String(_compare) + "秒"])
			comfirmed = true
			control_button.change_button_mode(control_button.NORMAL)

func _on_ControlButton_button_pressed():
	time_table.set_current_line(time_table.get_current_line() + 1)
	control_button.change_button_mode(control_button.DISABLED)
	yield(get_tree().create_timer(1.0), "timeout")
	control_button.change_button_mode(control_button.NORMAL)
