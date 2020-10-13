extends Node

const JAPAN_UTC_TIME:int = 9*60*60

var execute_date:Dictionary

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

func merge_dict(dest, source):
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

func convert_second_to_dict(_sec):
	var _hour = _sec / 3600
	var _min = (_sec % 3600) / 60
	var _s = _sec % 60
	return {"hour": _hour, "minute": _min, "second": _s}
