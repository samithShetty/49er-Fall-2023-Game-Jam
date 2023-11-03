extends CharacterBody2D
@export var player: CharacterBody2D
@export var springForce: float

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _physics_process(delta):
	var distance = player.position - position  
	velocity += distance * springForce
	#velocity *= 0.95
	move_and_slide()
	
