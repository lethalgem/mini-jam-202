class_name DeathBubbleRigidBody2D extends RigidBody2D

@export var speed: float = 300.0
	
func spawn(move_in_direction: Vector2):
	linear_velocity = move_in_direction * speed
