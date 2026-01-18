class_name GameManager extends Node2D

@export var counter_ui : CountersUI

var time_since_time_update: float = 0
var total_time_survived_sec: float = 0

func _physics_process(delta: float):
	time_since_time_update += delta
	if time_since_time_update >= 1.0:
		total_time_survived_sec += 1.0
		update_time_survived()
		time_since_time_update = 0

func update_time_survived():
	var time_survived_min : int = total_time_survived_sec / 60
	var remaining_time_survived_sec : int = fmod(total_time_survived_sec, 60)
	# TODO update ui here
	
	if time_survived_min >= 1:
		counter_ui.time_label.text ="Time Survived " + str(time_survived_min) + ":" + str(remaining_time_survived_sec)
	else: 
		counter_ui.time_label.text ="Time Survived " + str(remaining_time_survived_sec)
