class_name PlayerCharacterBody2D extends CharacterBody2D

@export var animated_sprite_2D: AnimatedSprite2D
@export var attack_area_2D: Area2D
@export var attack_collision_shape_2D: CollisionShape2D

@export var attack_speed: float = 1.0
@export var idle_speed: float = 1.0
@export var death_speed: float = 1.0
@export var speed := 300.0
@export var health := 10

var death_bubble_controller_scene := preload("res://scenes/death_bubble_controller.tscn")
var taking_damage := false

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

func walk():
	attack_area_2D.monitoring = false
	animated_sprite_2D.play("walk", idle_speed)

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
		if attack_collision_shape_2D.position.x > 0:
			attack_collision_shape_2D.position.x = -attack_collision_shape_2D.position.x
	if Input.is_action_pressed("ui_right"):
		direction += 1
		animated_sprite_2D.flip_h = false
		if attack_collision_shape_2D.position.x < 0:
			attack_collision_shape_2D.position.x = -attack_collision_shape_2D.position.x

	velocity.x = direction * speed
	velocity.y = 0 

	if velocity.x != 0 and not attack_area_2D.monitoring and not taking_damage:
		walk()
	elif velocity.x == 0 and not attack_area_2D.monitoring and not taking_damage:
		idle()

	move_and_slide()
	
	if Input.is_action_just_pressed("attack"):
		attack()


func take_damage():
	if health >= 1:
		health -= 1
		animated_sprite_2D.play("damage")
		animated_sprite_2D.frame = 0
		taking_damage = true
		# TODO: deal with animation ending, not having a state machine is f-ing us
	else:
		die()


func _on_attack_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage()
