class_name OptionMenu extends Control

signal back_button_pressed
@export var button_sound : AudioStreamPlayer
# Called when the node enters the scene tree for the first time.
func _on_back_button_pressed() -> void:
	back_button_pressed.emit()
	button_sound.play()
