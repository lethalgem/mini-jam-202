class_name GameMode extends Node2D

signal enemy_died
@export var platforms: TileMapLayer
@export var character: PlayerCharacterBody2D

@onready var enemy_scene = preload("res://scenes/enemy_test.tscn")

@export var min_spawn := 0.5
@export var max_spawn := 1.0

var spawn_timer: Timer

func _ready():
	spawn_timer = Timer.new()
	spawn_timer.one_shot = false
	spawn_timer.wait_time = randf_range(min_spawn, max_spawn)
	spawn_timer.timeout.connect(_on_spawn_timeout)
	add_child(spawn_timer)
	disable_and_hide()


func enable_and_show():
	# enable collision and show the scene
	platforms.collision_enabled = true
	character.collision_layer = 1
	spawn_timer.start()


func disable_and_hide():
	# disable collision and hide
	platforms.collision_enabled = false
	character.collision_layer = 0
	spawn_timer.stop()


func pause():
	disable_and_hide()
	set_pause_subtree(self, true)


func unpause():
	enable_and_show()
	set_pause_subtree(self, false)


# Pauses every node starting at the root and deeper
func set_pause_subtree(root: Node, should_pause: bool) -> void:
	var process_setters = ["set_process",
	"set_physics_process",
	"set_process_input",
	"set_process_unhandled_input",
	"set_process_unhandled_key_input",
	"set_process_shortcut_input"]
	
	for setter in process_setters:
		root.propagate_call(setter, [!should_pause])


func _on_spawn_timeout():
	generateEnemy()
	

var floodCount := 0
var floodAmount := 7

func floodSpawn():
	
	for i in range(floodAmount):
		generateEnemy()
		await get_tree().create_timer(0.05).timeout
		
	floodCount += 1
	floodAmount *= 1.3
	
		
func generateEnemy():
	var enemy := enemy_scene.instantiate() as Enemy
	
	var rect = get_viewport().get_visible_rect()
	var randomValue = randf_range(.25, .75)

	var spawn_x = rect.size.x * randomValue
	var spawn_y = rect.position.y  # top of the screen

	enemy.global_position = Vector2(spawn_x, spawn_y)
	enemy.speed = randf_range(65, 350)
	
	var scale_value = randf_normal(2.5, 1)
	while scale_value > 5.0 or scale_value < 2.0:
		scale_value = randf_normal(2.5, 1)
	
	enemy.scale = Vector2(scale_value, scale_value)
	
	add_child(enemy)
	enemy.connect('enemy_death',enemy_died.emit)
	
	spawn_timer.wait_time = randf_range(min_spawn, max_spawn)
	
	
func randf_normal(mean := 1.0, std_dev := 0.15) -> float:
	var u1 = randf()
	var u2 = randf()
	var z0 = sqrt(-2.0 * log(u1)) * cos(TAU * u2)
	return mean + z0 * std_dev


func _on_player_character_body_2d_poweredup() -> void:
	floodSpawn()
