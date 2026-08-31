extends RefCounted

var traces: Array = []


func record(trace) -> void:
	traces.append(trace)
