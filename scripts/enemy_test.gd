extends CharacterBody2D

class_name Enemy

@export var Collision:CollisionShape2D
@export var Sprite:AnimatedSprite2D
@export var speed: float = 100.0
@export var gravity := 800.0
@export var falling := true

# Called when the node enters the scene tree for the first time.
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
	velocity.x = direction.x * speed
	
	if falling:
		velocity.y += gravity * delta
	else:
		velocity.y = 0
		
	#print(velocity)
		
	move_and_slide()
	
	if get_slide_collision_count() == 0:
		falling = true
	else:
		for i in range(get_slide_collision_count()):
			var c = get_slide_collision(i)
			if c.get_normal().x == 0 and c.get_normal().y == -1:
				falling = false



func pick_new_direction():
	var randomValue = randf()

	if falling:
		if direction == stay:
			direction = stay
		else:
			if randomValue < .5:
				direction = left
				Sprite.flip_h = true
			else:
				direction = right
				Sprite.flip_h = false
		
	else:
		if randomValue < .33:
			direction = stay
		elif randomValue < .67:
			direction = left
			Sprite.flip_h = true
		else:
			direction = right
			Sprite.flip_h = false
		
	
	
