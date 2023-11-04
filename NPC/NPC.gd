extends CharacterBody2D
class_name NPC

enum State {IDLE, ROAM, AGGRO}

var player: CharacterBody2D
var state: State = State.ROAM
var chase_velocity : Vector2
var target_location: Vector2
var push_forces: Vector2
@export var move_speed: float
@export var push_force: float
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
			if position.distance_squared_to(target_location) < 10:
				pause_roam()

func _physics_process(delta):
	chase_velocity = (target_location - position).normalized() * move_speed
	velocity = chase_velocity + push_forces
	push_forces *= 0.95
	update_sprite()
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
	
	if body is Boomerang:
		#var is_backstab = chase_velocity.normalized().dot(body.velocity.normalized()) > 0.2
		var is_backstab = (body.velocity.x < 0 == sprite.flip_h) and chase_velocity.normalized().dot(body.velocity.normalized()) > 0.2
		if state == State.AGGRO and is_backstab:
				queue_free()
			
		else:
			push_force += 1 
			move_speed *= 1.2
			push_forces += body.velocity
			state = State.AGGRO

func set_roam_target():
	target_location = position + randi_range(400, 800)*Vector2.from_angle(randf()*2*PI) 

func pause_roam():
	target_location = position
	velocity = Vector2.ZERO
	state = State.IDLE
	await get_tree().create_timer(randf_range(2.0, 5.0)).timeout
	if state == State.IDLE: # State might have changed (e.g. aggro'ed on player) during idle
		state = State.ROAM
		set_roam_target()
