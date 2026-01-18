class_name OptionMenu extends Control

signal back_button_pressed
@export var button_sound : AudioStreamPlayer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_back_button_pressed() -> void:
	back_button_pressed.emit()
	button_sound.play()
