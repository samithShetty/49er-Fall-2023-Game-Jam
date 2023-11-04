extends CharacterBody2D
class_name NPC

enum State {IDLE, ROAM, AGGRO}

var player: CharacterBody2D
var state: State = State.ROAM
var is_aggro: bool = false
var chase_direction : Vector2
var target_location: Vector2
@export var move_speed: float
@onready var sprite = $AnimatedSprite2D
@onready var nav_agent = $NavigationAgent2D

func _ready():
	player = get_node("../Player")
	set_roam_target()
	
func _process(delta):
	match state:
		State.AGGRO:
			target_location = player.position
			
		State.ROAM:
			if position.distance_squared_to(target_location) < 20:
				pause_roam()


	chase_direction = (target_location - position).normalized()
	velocity = chase_direction * move_speed
	update_sprite()

func _physics_process(delta):
	move_and_slide()
	
func update_sprite():
	if velocity.x < 0:
		sprite.flip_h = true
	elif velocity.x > 0:
		sprite.flip_h = false
	
	if state == State.IDLE:
		sprite.play("idle")
	else:
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
	target_location = position + randi_range(400, 800)*Vector2.from_angle(randf()*2*PI) 

func pause_roam():
	target_location = position
	velocity = Vector2.ZERO
	state = State.IDLE
	await get_tree().create_timer(randf_range(2.0, 5.0)).timeout
	state = State.ROAM
	set_roam_target()
