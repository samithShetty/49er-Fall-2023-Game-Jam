class_name Boomerang extends CharacterBody2D
@export var player: CharacterBody2D
@export var springForce: float
@export var maxSpeed: Vector2
@onready var timer = $Timer


func _physics_process(delta):
	var distance = player.position - position
	velocity += distance * springForce
	velocity*= 0.98
	velocity.clamp(-maxSpeed, maxSpeed)
	rotation_degrees += distance.length()/15
	move_and_slide()

func _on_timer_timeout():
	springForce *1.1
	timer.start()
