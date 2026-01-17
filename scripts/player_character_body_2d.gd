class_name PlayerCharacterBody2D extends CharacterBody2D

# click to teleport (check if empty or zombie)
# needs attack, teleport, idle

# keep it simple, no state machine for now, just override

@export var animated_sprite_2D: AnimatedSprite2D
@export var teleport_speed: float = 1.0
@export var attack_speed: float = 1.0
@export var idle_speed: float = 1.0

func _ready():
	idle()

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
	idle()

func idle():
	animated_sprite_2D.play("idle", idle_speed)
