class_name GameManager extends Node2D

@export var counter_ui : CountersUI


@onready var main_menu = $CanvasLayer2
@onready var option_menu = $CanvasLayer4

var time_since_time_update: float = 0
var total_time_survived_sec: float = 0

func _ready() -> void:
	main_menu.visible = true
	
func _physics_process(delta: float):
	time_since_time_update += delta
	if time_since_time_update >= 1.0:
		total_time_survived_sec += 1.0
		update_time_survived()
		time_since_time_update = 0

func update_time_survived():
	var time_survived_min : int = int(total_time_survived_sec / 60)
	var remaining_time_survived_sec : int = int(fmod(total_time_survived_sec, 60))
	
	if time_survived_min >= 1:
		counter_ui.time_label.text ="Time Survived " + str(time_survived_min) + ":" + str(remaining_time_survived_sec)
	else: 
		counter_ui.time_label.text ="Time Survived " + str(remaining_time_survived_sec)

func _on_title_option_but_pressed() -> void:
	print("signal for option menu pressed working")
	option_menu.visible = true
	main_menu.visible = false


func _on_option_menu_back_button_pressed() -> void:
	print("back button pressed")
	option_menu.visible = false
	main_menu.visible = true
