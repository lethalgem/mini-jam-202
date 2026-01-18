class_name GameManager extends Node2D

@export var counter_ui: CountersUI
@export var game_mode: GameMode

@onready var main_menu = $CanvasLayer2
@onready var option_menu = $CanvasLayer4
@onready var option_menu_button = $CanvasLayer4/OptionMenu/VBoxContainer/BackButton
@onready var world_test := $CanvasLayer2/WorldTest as WorldTest

var time_since_time_update: float = 0
var total_time_survived_sec: float = 0
var is_paused := true:
	set(should_pause):
		if should_pause:
			game_mode.pause()
			option_menu.visible = true
			main_menu.visible = false
			option_menu_button.visible = false
		else:
			game_mode.unpause()
			option_menu.visible = false
			main_menu.visible = false
			world_test.clear_and_disable()
		is_paused = should_pause


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


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		is_paused = !is_paused


func _on_title_option_but_pressed() -> void:
	option_menu.visible = true
	main_menu.visible = false


func _on_option_menu_back_button_pressed() -> void:
	option_menu.visible = false
	main_menu.visible = true


func _on_title_start_but_pressed() -> void:
	is_paused = false
