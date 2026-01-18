class_name DeathBubbleController extends Node2D

@export var count_per_wave: int = 8
@export var wave_count: int = 3

var death_bubble = preload("res://scenes/death_bubble_rigid_body_2d.tscn")

func start():
	for i in range(1, wave_count + 1):
		spawn_wave(i)

func spawn_wave(current_wave_count):
	var angle_step := TAU / count_per_wave

	for i in range(count_per_wave):
		var angle := i * angle_step
		var direction := Vector2(cos(angle), sin(angle))
		
		var death_bubble_instance: DeathBubbleRigidBody2D = death_bubble.instantiate()
		add_child(death_bubble_instance)
		death_bubble_instance.global_position = global_position
		death_bubble_instance.speed /= current_wave_count
		death_bubble_instance.scale = scale
		death_bubble_instance.spawn(direction)
