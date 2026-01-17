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


func _on_start_button_pressed() -> void:
	start_pressed_animation()

func start_pressed_animation():
	var hover_color = start_button.get_theme_color("font_hover_color")
	var pressed_color = start_button.get_theme_color('font_outline_color')
	var tween := create_tween()
	var duration := 0.20
	
	tween.tween_property(start_button,"theme_override_colors/font_focus_color",pressed_color,duration).set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(start_button,"theme_override_colors/font_focus_color",hover_color,duration).set_trans(Tween.TRANS_BOUNCE)
	tween.set_loops()
	print("ayo")
