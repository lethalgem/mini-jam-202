class_name GameManager extends Node2D

@export var counter_ui: CountersUI
@export var game_mode: GameMode
@export var background_music : Node

@onready var main_menu = $CanvasLayer2
@onready var option_menu = $CanvasLayer4
@onready var game_over_menu = $CanvasLayer3
@onready var counter_ui_layer = $CanvasLayer
@onready var option_menu_button = $CanvasLayer4/OptionMenu/VBoxContainer/BackButton
@onready var world_test := $CanvasLayer2/WorldTest as WorldTest

var death_counter: int = 0
var time_since_time_update: float = 0
var total_time_survived_sec: float = 0
var is_paused := true:
	set(should_pause):
		if should_pause:
			game_mode.pause()
			option_menu.show()
			main_menu.hide()
			option_menu_button.hide()
		else:
			game_mode.unpause()
			option_menu.hide()
			main_menu.hide()
			world_test.clear_and_disable()
			counter_ui_layer.show()
		is_paused = should_pause


func _ready() -> void:
	main_menu.visible = true
	
	
func _physics_process(delta: float):
	if not is_paused:
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
	background_music.crossfade_to()


func _on_player_character_body_2d_died() -> void:
	await get_tree().create_timer(1.0).timeout
	game_over_menu.show()


func _on_game_over_play_again_pressed() -> void:
	await get_tree().create_timer(0.5).timeout
	get_tree().reload_current_scene()


func _on_game_mode_enemy_died() -> void:
	death_counter += 1
	counter_ui.kill_counter_label.text ="Kill " + str(death_counter)
