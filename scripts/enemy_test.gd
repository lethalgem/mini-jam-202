class_name Enemy extends CharacterBody2D

@export var Collision:CollisionShape2D
@export var Sprite:AnimatedSprite2D
@export var attack_collision_shape_2D: CollisionShape2D
@export var speed: float = 100.0
@export var gravity := 800.0
@export var falling := true
@export var health := 3
@export var should_move := true

func _ready() -> void:
	Sprite.play("swipe")
	
	randomize()
	pick_new_direction()

var stay := Vector2(0, 0)
var left := Vector2(-1, 0)
var right := Vector2(1, 0)
var direction := right

var lastTimeUpdate := 0
var timePassed := 0.0


func _process(delta):
	timePassed += + delta
	if int(timePassed - lastTimeUpdate) >= 1:
		lastTimeUpdate += 1
		pick_new_direction()
	
	
func _physics_process(delta):
	if should_move:
		velocity.x = direction.x * speed
		
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

func take_damage():
	if health >= 1:
		health -= 1
		Sprite.play("damaged")
		Sprite.frame = 0
	else:
		Sprite.play("die")
		await Sprite.animation_finished
		queue_free()
		

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
	print(body)
	if body.has_method("take_damage"):
		body.take_damage()
