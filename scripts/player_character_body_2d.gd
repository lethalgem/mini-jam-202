class_name PlayerCharacterBody2D extends CharacterBody2D

@export var animated_sprite_2D: AnimatedSprite2D

@export var teleport_speed: float = 2.0
@export var attack_speed: float = 1.0
@export var idle_speed: float = 1.0
@export var death_speed: float = 1.0
@export var attack_cooldown: float = 1.0
@export var speed := 300.0
@export var gravity := 800.0

var death_bubble_controller_scene := preload("res://scenes/death_bubble_controller.tscn")
var power_up_blast := preload("res://scenes/power_up_blast.tscn")

var falling := false

func _ready():
	idle()

func _input(event):
	if event.is_action_pressed("radial_blast"):
		powerUp()

func start_teleport(location: Vector2):
	animated_sprite_2D.play("teleport_start", teleport_speed)
	await animated_sprite_2D.animation_finished
	global_position = location
	animated_sprite_2D.play("teleport_end", teleport_speed)
	await animated_sprite_2D.animation_finished
	attack()

func attack():
	animated_sprite_2D.play("slash", attack_speed)
	await animated_sprite_2D.animation_finished
	#die()
	idle()

func powerUp():
	
	print(global_position)
	
	var blast = power_up_blast.instantiate()
	blast.global_position = global_position
	get_parent().add_child(blast)
	
	scale *= 1.25
	
	
func idle():
	animated_sprite_2D.play("idle", idle_speed)

func die():
	animated_sprite_2D.play("death_explode", death_speed)
	await animated_sprite_2D.animation_finished
	
	var death_bubble_controller: DeathBubbleController = death_bubble_controller_scene.instantiate()
	add_sibling(death_bubble_controller)
	death_bubble_controller.global_position = global_position
	death_bubble_controller.scale = scale
	death_bubble_controller.start()
	queue_free()


func _physics_process(delta):
	var direction := 0

	if Input.is_action_pressed("ui_left"):
		direction -= 1
		animated_sprite_2D.flip_h = true
	if Input.is_action_pressed("ui_right"):
		direction += 1
		animated_sprite_2D.flip_h = false
	
	velocity.x = direction * speed
	
	if falling:
		velocity.y += gravity * delta
	else:
		velocity.y = 0
	

	move_and_slide()
	
	if get_slide_collision_count() == 0:
		falling = true
	else:
		for i in range(get_slide_collision_count()):
			var c = get_slide_collision(i)
			if c.get_normal().x == 0 and c.get_normal().y == -1:
				falling = false
	
	if Input.is_action_just_pressed("attack"):
		attack()
	
	
