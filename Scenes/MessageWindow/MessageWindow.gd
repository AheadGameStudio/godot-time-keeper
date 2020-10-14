extends MarginContainer

signal finish_text

func _ready():
	var _date = Global.get_execute_date()
	var _table = Global.get_time_table()
	if _date == {}: set_text("実行する日付を設定してください")
	if _table == []: set_text("タイムテーブルを読み込んでください")

func set_text(_text:String):
	for i in range(_text.length()):
		yield(get_tree().create_timer(0.05), "timeout")
		$PanelContainer/MarginContainer/Label.set_text(_text.left(i+1))
	yield(get_tree().create_timer(1.0), "timeout")
	emit_signal("finish_text")
