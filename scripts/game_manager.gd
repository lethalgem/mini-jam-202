class_name GameManager extends Node2D

var time_since_time_update: float = 0
var total_time_survived_sec: float = 0

func _physics_process(delta: float):
	time_since_time_update += delta
	if time_since_time_update >= 1.0:
		total_time_survived_sec += time_since_time_update
		update_time_survived()
		time_since_time_update = 0

func update_time_survived():
	var time_survived_min = total_time_survived_sec / 60
	var remaining_time_survived_sec = fmod(total_time_survived_sec, 60)
	
	# TODO update ui here
