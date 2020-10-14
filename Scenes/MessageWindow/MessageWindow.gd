extends MarginContainer

signal finish_text

var messages:Dictionary = {
	"set date" : "実行する日付を設定してください",
	"load file" : "タイムテーブルを読み込んでください",
	"adjust second" : "時間調整しています。少々お待ち下さい",
	"countdown to start" : "実行開始まで%s時間%s分%s秒です",
	"countdown to next" : "次のシーケンスまで%sです",
	"timeover count" : "%s押しです",
	"time wrapped" : "%s巻いています"
}

func _ready():
	var _err = Global.connect("update", self, "check_update")
	var _date = Global.get_execute_date()
	var _table = Global.get_time_table()
	if _date == {}: set_text(messages["set date"])
	if _table == []: set_text(messages["load file"])

func set_text(_text:String):
	for i in range(_text.length()):
		yield(get_tree().create_timer(0.05), "timeout")
		$PanelContainer/MarginContainer/Label.set_text(_text.left(i+1))
	yield(get_tree().create_timer(1.0), "timeout")
	emit_signal("finish_text")

func check_update():
	
	pass
