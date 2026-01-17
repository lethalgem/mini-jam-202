class_name DeathBubbleAnimatedSprite2D extends AnimatedSprite2D

@export var animation_speed: float = 1.0

func _ready():
	play("default", animation_speed)
