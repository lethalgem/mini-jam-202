class_name DeathBubbleRigidBody2D extends RigidBody2D

@export var collision_shape: CollisionShape2D
@export var animated_sprite: DeathBubbleAnimatedSprite2D
@export var speed: float = 300.0
	
func spawn(move_in_direction: Vector2):
	linear_velocity = move_in_direction * speed
	collision_shape.scale = scale
	animated_sprite.scale = scale
