extends Area2D

@export var max_radius := 500.0
@export var expand_speed := 1200.0
@export var damage := 1

@onready var collision := $CollisionShape2D
var circle := CircleShape2D.new()

func _ready():
	z_index = -10  # behind player
	circle.radius = 5
	collision.shape = circle
	
	# Collision: ONLY layer 3
	collision_layer = 1 << 2
	collision_mask  = 1 << 2
	
	monitoring = true
	monitorable = true

func _physics_process(delta):
	circle.radius += expand_speed * delta
	
	if circle.radius >= max_radius:
		queue_free()
	else:
		queue_redraw()

		
		
func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(damage)

func _draw():
	draw_circle(Vector2.ZERO, circle.radius, Color(.9, 1, 0, 0.4))
