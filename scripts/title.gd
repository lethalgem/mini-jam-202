class_name TitleScreen extends Control

@export var title_label: Label
@export var gen_button: Button
@export var button_sound : AudioStreamPlayer

signal start_but_pressed
signal option_but_pressed
signal play_again_pressed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame
	play_floating_animation()
	button_animation(gen_button)
func play_floating_animation() -> void: 
	var tween := create_tween()

	var position_offest := Vector2(0.0,10.0)
	var duration := 1.0
	tween.tween_property(title_label, "position", position_offest, duration)
	tween.tween_property(title_label, "position", -1.0*position_offest, duration)
	
	tween.set_loops()

func _on_start_button_pressed() -> void:
	start_but_pressed.emit()
	button_sound.play()

func button_animation(button:Button) -> void:
	print("pressed start game")
	var tween := create_tween()
	var hover_color = button.get_theme_color("font_hover_color")
	var pressed_color = button.get_theme_color('font_focus_color')
	var duration := 0.20
	tween.tween_property(button,"theme_override_colors/font_color",pressed_color,duration).set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(button,"theme_override_colors/font_color",hover_color,duration).set_trans(Tween.TRANS_BOUNCE)
	tween.set_loops()

func _on_option_button_pressed() -> void:
	option_but_pressed.emit()
	button_sound.play()


func _on_play_again_pressed() -> void:
	play_again_pressed.emit()
	button_sound.play()
