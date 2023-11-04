extends CharacterBody2D
class_name NPC

var player: CharacterBody2D
var is_aggro: bool = false
var chase_direction : Vector2
var target_location: Vector2
@export var move_speed: float
@onready var sprite = $AnimatedSprite2D
@onready var nav_agent = $NavigationAgent2D

func _ready():
	player = get_node("../Player")
	print(player)
	set_roam_target()
	print(is_aggro)
	
func _process(delta):
	print(is_aggro)
	if is_aggro:
		target_location = player.position
		
	elif position.distance_squared_to(target_location) < 200:
		set_roam_target()
		
	chase_direction = (target_location - position).normalized()
	velocity = chase_direction * move_speed
	update_sprite()

func _physics_process(delta):
	move_and_slide()
	
func update_sprite():
	sprite.flip_h = velocity.x < 0
	if velocity:
		sprite.play("run")

func _on_area_2d_body_entered(body):
	if body.name == "Boomerang":
		if is_aggro:
			if chase_direction.dot(body.velocity) > 0:
				queue_free()
			else:
				pass
		else:
			is_aggro = true

func set_roam_target():
	target_location = position + randi_range(200, 500)*Vector2.from_angle(randf()*2*PI) 
