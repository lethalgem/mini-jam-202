extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()


@export var EnemyCharacter:CharacterBody2D


var stay := Vector2(0, 0)
var left := Vector2(-1, 0)
var right := Vector2(1, 0)
var direction := right

@export var speed := 100

@export var onGround := false

var lastTimeUpdate := 0
var timePassed := 0.0

func _process(delta):
	timePassed += + delta
	if int(timePassed - lastTimeUpdate) >= 2:
		lastTimeUpdate += 2
		pick_new_direction()
	
	

func _physics_process(delta):
	EnemyCharacter.velocity.x = right.x * speed
	
	if not onGround:
		EnemyCharacter.velocity.y += 1
		
	EnemyCharacter.move_and_slide()


func pick_new_direction():
	var randomValue = randf()

	if randomValue < .33:
		direction = stay
	elif randomValue < .67:
		direction = left
	else:
		direction = right
		
	direction = left
	
	
