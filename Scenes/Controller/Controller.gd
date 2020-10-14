extends Control

onready var time_table := $Container/TimeTable
onready var control_button := $Container/ControlButton
onready var message_window := $Container/MessageWindow
onready var current_sequence := $Container/CurrentSequence

func _ready():
#	Global.check_execute()
	control_button.change_button_mode(control_button.DISABLED)
