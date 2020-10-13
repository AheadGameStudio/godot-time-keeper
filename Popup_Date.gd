extends Panel

onready var year_box = get_node("./VBoxContainer/GridContainer/Year")
onready var month_box = get_node("./VBoxContainer/GridContainer/Month")
onready var day_box = get_node("./VBoxContainer/GridContainer/Day")

func _ready():
	var _time = Global.get_japan_time(OS.get_unix_time())

	year_box.set_placeholder(_time["year"] as String)
	month_box.set_placeholder(_time["month"] as String)
	day_box.set_placeholder(_time["day"] as String)
