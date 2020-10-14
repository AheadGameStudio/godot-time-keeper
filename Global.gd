extends Node

const JAPAN_UTC_TIME:int = 9*60*60

signal set_time_table
signal set_execute_date

var _time_table:Array setget set_time_table, get_time_table
var _execute_date:Dictionary setget set_execute_date, get_execute_date

func set_time_table(_val):
	if not _time_table.empty():
		_time_table.clear()
	_time_table = _val
	print("タイムテーブルがセットされました")
	emit_signal("set_time_table")

func get_time_table():
	return _time_table

func set_execute_date(_val):
	_execute_date = _val
	print("実行する日付が設定されました")
	emit_signal("set_execute_date")

func get_execute_date():
	return _execute_date

func check_execute():
	if get_time_table() == null or get_execute_date() == null:
		return false
	return true

func get_japan_time(_unix_time):
	return OS.get_datetime_from_unix_time(_unix_time + JAPAN_UTC_TIME)

func file_to_array(_path, _offset = 0):
	var _arr:Array
	var _file = File.new()
	_file.open(_path, File.READ)
	
	while !_file.eof_reached():
		var _line = _file.get_csv_line()
		if _line[0] == "": break
		_arr.push_back(_line)
		
	_file.close()
	
	if _offset > 0:
		# warning-ignore:unused_variable
		for i in range(_offset):
			_arr.remove(0)
			
	return _arr

#----------------------------------------------
#TODO: 新しい辞書を返すように修正する
#----------------------------------------------
func merge_dict(date_dict:Dictionary, source:Dictionary):
	var dest = date_dict.duplicate()
	for key in source:                     # go via all keys in source
		if dest.has(key):                  # we found matching key in dest
			var dest_value = dest[key]     # get value 
			var source_value = source[key] # get value in the source dict           
			if typeof(dest_value) == TYPE_DICTIONARY:       
				if typeof(source_value) == TYPE_DICTIONARY: 
					merge_dict(dest_value, source_value)  
				else:
					dest[key] = source_value # override the dest value
			else:
				dest[key] = source_value     # add to dictionary 
		else:
			dest[key] = source[key]          # just add value to the dest
	return dest

func convert_second_to_dict(_sec):
	var _hour = _sec / 3600
	var _min = (_sec % 3600) / 60
	var _s = _sec % 60
	return {"hour": _hour, "minute": _min, "second": _s}
