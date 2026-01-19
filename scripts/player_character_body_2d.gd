class_name PlayerCharacterBody2D extends CharacterBody2D

@export var animated_sprite_2D: AnimatedSprite2D
@export var attack_area_2D: Area2D
@export var attack_collision_shape_2D: CollisionShape2D
@export var sound_player_2d: SoundPlayer2D

@export var attack_speed: float = 1.0
@export var idle_speed: float = 1.0
@export var death_speed: float = 1.0
@export var speed := 300.0
@export var health := 1
@export var attack_sounds: Array[SoundSample]
@export var damaged_sounds: Array[SoundSample]
@export var death_sounds: Array[SoundSample]

signal died

enum State {
	IDLE,
	WALK,
	ATTACK,
	DAMAGED,
	DEAD
}

var state: State = State.IDLE
var death_bubble_controller_scene := preload("res://scenes/death_bubble_controller.tscn")
var sword_swing_sound := preload("res://assets/sfx/sword-air-swing-2-437695.mp3")
var taking_damage := false

func _ready():
	attack_area_2D.monitoring = false
	attack_area_2D.visible = false

func die():
	attack_area_2D.monitoring = false
	animated_sprite_2D.play("death_explode", death_speed)
	await animated_sprite_2D.animation_finished
	var death_sound_player = SoundPlayer2D.new()
	add_sibling(death_sound_player)
	death_sound_player.play_from_samples(death_sounds)
	
	var death_bubble_controller: DeathBubbleController = death_bubble_controller_scene.instantiate()
	add_sibling(death_bubble_controller)
	death_bubble_controller.global_position = global_position
	death_bubble_controller.scale = scale
	death_bubble_controller.start()
	queue_free()
	
	died.emit()

func _physics_process(delta):
	if state in [State.ATTACK, State.DAMAGED, State.DEAD]:
		return
	
	var direction := 0
	
	if state in [State.WALK, State.IDLE]:
		if Input.is_action_pressed("ui_left"):
			direction -= 1
			animated_sprite_2D.flip_h = true
			if attack_collision_shape_2D.position.x > 0:
				attack_collision_shape_2D.position.x = -attack_collision_shape_2D.position.x
		elif Input.is_action_pressed("ui_right"):
			direction += 1
			animated_sprite_2D.flip_h = false
			if attack_collision_shape_2D.position.x < 0:
				attack_collision_shape_2D.position.x = -attack_collision_shape_2D.position.x
		
		if velocity.x == 0:
			state = State.IDLE
		else:
			state = State.WALK
		
		if Input.is_action_just_pressed("attack"):
			start_attack()
	
	velocity.x = direction * speed
	velocity.y += 800 * delta # keep the character grounded
	
	move_and_slide()
	
	update_animation()

func update_animation():
	if state == State.DEAD:
		return

	match state:
		State.ATTACK:
			pass # attack animation already playing
		State.DAMAGED:
			pass # damage animation already playing
		State.WALK:
			if animated_sprite_2D.animation != "walk":
				animated_sprite_2D.play("walk", idle_speed)
		State.IDLE:
			if animated_sprite_2D.animation != "idle":
				animated_sprite_2D.play("idle", idle_speed)

func start_attack():
	if state in [State.DEAD, State.DAMAGED]:
		return

	state = State.ATTACK
	animated_sprite_2D.play("slash", attack_speed)
	sound_player_2d.play_from_samples(attack_sounds)
	attack_area_2D.monitoring = true
	attack_area_2D.visible = true
	

func take_damage():
	if state == State.DEAD:
		return

	attack_area_2D.monitoring = false
	attack_area_2D.visible = false

	health -= 1
	sound_player_2d.play_from_samples(damaged_sounds, true, 0.1)

	if health <= 0:
		state = State.DEAD
		die()
		return

	state = State.DAMAGED
	animated_sprite_2D.play("damage")
	animated_sprite_2D.frame = 0

	await animated_sprite_2D.animation_finished
	state = State.IDLE


func _on_attack_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage") and body is Enemy:
		body.take_damage()


func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite_2D.animation == "slash":
		attack_area_2D.monitoring = false
		attack_area_2D.visible = false
		state = State.IDLE
