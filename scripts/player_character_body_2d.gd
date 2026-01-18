class_name PlayerCharacterBody2D extends CharacterBody2D

@export var animated_sprite_2D: AnimatedSprite2D
@export var attack_area_2D: Area2D

@export var teleport_speed: float = 2.0
@export var attack_speed: float = 1.0
@export var idle_speed: float = 1.0
@export var death_speed: float = 1.0
@export var attack_cooldown: float = 1.0
@export var speed := 300.0

var death_bubble_controller_scene := preload("res://scenes/death_bubble_controller.tscn")

func _ready():
	idle()

func attack():
	animated_sprite_2D.play("slash", attack_speed)
	attack_area_2D.monitoring = true
	await animated_sprite_2D.animation_finished
	attack_area_2D.monitoring = false
	idle()

func idle():
	attack_area_2D.monitoring = false
	animated_sprite_2D.play("idle", idle_speed)

func die():
	attack_area_2D.monitoring = false
	animated_sprite_2D.play("death_explode", death_speed)
	await animated_sprite_2D.animation_finished
	
	var death_bubble_controller: DeathBubbleController = death_bubble_controller_scene.instantiate()
	add_sibling(death_bubble_controller)
	death_bubble_controller.global_position = global_position
	death_bubble_controller.scale = scale
	death_bubble_controller.start()
	queue_free()


func _physics_process(_delta):
	var direction := 0

	if Input.is_action_pressed("ui_left"):
		direction -= 1
		animated_sprite_2D.flip_h = true
	if Input.is_action_pressed("ui_right"):
		direction += 1
		animated_sprite_2D.flip_h = false

	velocity.x = direction * speed
	velocity.y = 0 

	move_and_slide()
	
	if Input.is_action_just_pressed("attack"):
		attack()


func _on_attack_area_2d_body_entered(body: Node2D) -> void:
	print(body)
	if body.has_method("take_damage"):
		body.take_damage()
