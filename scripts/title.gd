extends Control

@export var title_label: Label
@export var start_button: Button
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play_floating_animation()

func play_floating_animation() -> void:
	var tween := create_tween()
	
	var position_offest := Vector2(0.0,10.0)
	var duration := 1.0
	tween.tween_property(title_label, "position", position_offest, duration)
	tween.tween_property(title_label, "position", -1.0*position_offest, duration)
	
	tween.set_loops()
