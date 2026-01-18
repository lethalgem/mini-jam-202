class_name WorldTest extends Node2D

@onready var enemy_scene = preload("res://scenes/enemy_test.tscn")
	
@export var min_spawn := 0.05
@export var max_spawn := 0.3

var spawn_timer: Timer

func _ready():
	randomize()
	spawn_timer = Timer.new()
	spawn_timer.autostart = true
	spawn_timer.one_shot = false
	spawn_timer.wait_time = randf_range(min_spawn, max_spawn)
	spawn_timer.timeout.connect(_on_spawn_timeout)
	add_child(spawn_timer)

func _on_spawn_timeout():
	var enemy := enemy_scene.instantiate() as Enemy
	
	var rect = get_viewport().get_visible_rect()
	var randomValue = randf_range(.25, .75)

	var spawn_x = rect.size.x * randomValue
	var spawn_y = rect.position.y  # top of the screen

	enemy.global_position = Vector2(spawn_x, spawn_y)
	enemy.speed = randf_range(65, 350)
	
	var scale_value = randf_normal(1.3, 1)
	while scale_value > 4:
		scale_value = randf_normal(1.3, 1)
	scale_value = max(scale_value, .7)
	
	enemy.scale = Vector2(scale_value, scale_value)
	
	get_parent().add_child(enemy)
	
	spawn_timer.wait_time = randf_range(min_spawn, max_spawn)
	
func randf_normal(mean := 1.0, std_dev := 0.15) -> float:
	var u1 = randf()
	var u2 = randf()
	var z0 = sqrt(-2.0 * log(u1)) * cos(TAU * u2)
	return mean + z0 * std_dev

func clear_and_disable():
	spawn_timer.stop()
	for child in get_parent().get_children():
		if child is Enemy:
			child.queue_free()

func reenable():
	spawn_timer.start()
	
	
	
