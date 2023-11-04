extends CharacterBody2D
class_name NPC

var player: CharacterBody2D
var is_aggro: bool = false
var chase_direction : Vector2
@export var move_speed: float
@onready var sprite = $AnimatedSprite2D
@onready var nav_agent = $NavigationAgent2D

func _ready():
	player = get_node("../Player")
	print(player)

func _process(delta):
	if is_aggro:
		chase_direction = (player.position - position).normalized()
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
			if abs(rad_to_deg(chase_direction.angle_to(body.velocity))) < 15:
				queue_free()
		else:
			is_aggro = true
