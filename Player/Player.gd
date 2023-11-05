extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D
@onready var camera = $Camera2D
@onready var audio = $AudioStreamPlayer2D
@export var move_speed: float
var move_input: Vector2
var push_forces: Vector2
var can_throw:bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_sprite()
	

func throw_boomerang():
	var throwForce = 1800
	var direction = (get_global_mouse_position() - position).normalized()
	var boomerang = preload("res://Boomerang/Boomerang.tscn").instantiate()
	boomerang.velocity = direction * throwForce
	boomerang.position = position + direction*150
	boomerang.player = self
	add_sibling(boomerang)
	play_sound("throw")

func _physics_process(delta):
	move_input = Input.get_vector("move_left", "move_right", "move_up", "move_down") * move_speed
	velocity = move_input + push_forces
	push_forces *= 0.92
	move_and_slide()

func _input(event):
	if event.is_action_pressed("throw") and can_throw:
		throw_boomerang()
		can_throw = false

func update_sprite():
	if velocity != Vector2.ZERO:
		sprite.play("run")
		if velocity.x < 0:
			sprite.flip_h = true
		elif velocity.x > 0:
			sprite.flip_h = false
	else:
		sprite.play("idle")

func _on_area_2d_body_entered(body):
	if body is Boomerang:
		Global.end_game()
	elif body is NPC and body.state == body.State.AGGRO:
		push_forces += (position - body.position) * body.push_force
		play_sound("push")
		
func play_sound(sound: String):
	var throw_sound = preload("res://Assets/Sound/throw.wav")
	var push_sound = preload("res://Assets/Sound/push.wav")
	if audio.is_playing():
		return
	
	match sound:
		"throw":
			audio.volume_db = 5
			audio.stream = throw_sound
		"push":
			audio.volume_db = 10
			audio.stream = push_sound
	audio.play()
