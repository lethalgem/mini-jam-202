class_name Enemy extends CharacterBody2D

signal enemy_death

@export var Collision:CollisionShape2D
@export var Sprite:AnimatedSprite2D
@export var attack_area_2D: Area2D
@export var attack_collision_shape_2D: CollisionShape2D
@export var sound_player: SoundPlayer2D
@export var speed: float = 100.0
@export var gravity := 800.0
@export var falling := true
@export var health := 3
@export var should_move := true
@export var damaged_sounds: Array[SoundSample]
@export var death_sounds: Array[SoundSample]

const ATTACK_START_FRAME := 3
const ATTACK_END_FRAME := 5

enum State {
	IDLE,
	WALK,
	ATTACK,
	DAMAGED,
	DEAD
}

var stay := Vector2(0, 0)
var left := Vector2(-1, 0)
var right := Vector2(1, 0)
var direction := right
var lastTimeUpdate := 0
var timePassed := 0.0
var attack_cooldown := 1.0
var attack_timer := 0.0
var has_hit := false
var state: State = State.IDLE

func _ready() -> void:
	attack_area_2D.monitoring = false
	attack_area_2D.visible = false
	health = int(scale.x)
	randomize()
	pick_new_direction()


func _process(delta):
	attack_timer += delta

	if state in [State.IDLE, State.WALK] and attack_timer >= attack_cooldown:
		attack_timer = 0
		start_attack()

	timePassed += delta
	if int(timePassed - lastTimeUpdate) >= 1:
		lastTimeUpdate += 1
		pick_new_direction()


func _physics_process(delta):
	if state in [State.ATTACK, State.DAMAGED, State.DEAD]:
		move_and_slide()
		return

	if should_move:
		velocity.x = direction.x * speed
	else:
		velocity.x = 0

	if falling:
		velocity.y += gravity * delta
	else:
		velocity.y = 0

	move_and_slide()

	falling = true
	for i in range(get_slide_collision_count()):
		var c = get_slide_collision(i)
		if c.get_normal().y == -1:
			falling = false
			break

	if velocity.x == 0:
		state = State.IDLE
	else:
		state = State.WALK
				
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
			if Sprite.animation != "chill":
				Sprite.play("chill")
		State.IDLE:
			if Sprite.animation != "chill":
				Sprite.play("chill")

func start_attack():
	if state in [State.DEAD, State.DAMAGED]:
		return

	if falling:
		return

	state = State.ATTACK
	has_hit = false
	Sprite.play("swipe")


func take_damage(damage=1):
	if state == State.DEAD:
		return

	attack_area_2D.monitoring = false
	attack_area_2D.visible = false

	#health -= 1
	health -= damage
	
	var scaleValue = max(int(health / 2), 1)
	scaleValue = max(scaleValue, 2)
	scale = Vector2(scaleValue, scaleValue)

	if health <= 0:
		enemy_death.emit()
		state = State.DEAD
		Sprite.play("die")
		sound_player.play_from_samples(death_sounds)
		await Sprite.animation_finished
		queue_free()
		return

	state = State.DAMAGED
	Sprite.play("damaged")
	Sprite.frame = 0
	sound_player.play_from_samples(damaged_sounds)

	await Sprite.animation_finished
	state = State.IDLE


func pick_new_direction():
	var randomValue = randf()

	if falling:
		if direction == stay:
			direction = stay
		else:
			if randomValue < .5:
				direction = left
				Sprite.flip_h = true
				if attack_collision_shape_2D.position.x > 0:
					attack_collision_shape_2D.position.x = -attack_collision_shape_2D.position.x
			else:
				direction = right
				Sprite.flip_h = false
				if attack_collision_shape_2D.position.x < 0:
					attack_collision_shape_2D.position.x = -attack_collision_shape_2D.position.x
		
	else:
		if randomValue < .33:
			direction = stay
		elif randomValue < .67:
			direction = left
			Sprite.flip_h = true
			if attack_collision_shape_2D.position.x > 0:
				attack_collision_shape_2D.position.x = -attack_collision_shape_2D.position.x
		else:
			direction = right
			Sprite.flip_h = false
			if attack_collision_shape_2D.position.x < 0:
				attack_collision_shape_2D.position.x = -attack_collision_shape_2D.position.x


func _on_attacking_area_2d_body_entered(body: Node2D) -> void:
	if state != State.ATTACK or has_hit:
		return

	if body.has_method("take_damage"):
		body.take_damage()
		has_hit = true


func _on_animated_sprite_2d_animation_finished() -> void:
	if Sprite.animation == "swipe":
		attack_area_2D.monitoring = false
		attack_area_2D.visible = false
		attack_timer = 0
		state = State.IDLE


func _on_animated_sprite_2d_frame_changed() -> void:
	if state != State.ATTACK or Sprite.animation != "swipe":
		return

	var frame := Sprite.frame

	var active := frame >= ATTACK_START_FRAME and frame <= ATTACK_END_FRAME
	attack_area_2D.monitoring = active
	attack_area_2D.visible = active
