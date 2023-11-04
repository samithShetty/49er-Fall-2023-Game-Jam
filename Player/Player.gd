extends CharacterBody2D

@export var moveSpeed: float
var canThrow:bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move_and_slide()

func throw_boomerang():
	var throwForce = 1500
	var direction = (get_global_mouse_position() - position).normalized()
	var boomerang = preload("res://Boomerang/Boomerang.tscn").instantiate()
	boomerang.velocity = direction * throwForce
	boomerang.position = position + direction*50
	boomerang.player = self
	add_sibling(boomerang)

func _physics_process(delta):
	velocity = Input.get_vector("move_left", "move_right", "move_up", "move_down") * moveSpeed

func _input(event):
	if event.is_action_pressed("throw") and canThrow:
		throw_boomerang()
		canThrow = false
