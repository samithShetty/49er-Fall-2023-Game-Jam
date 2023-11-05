extends Node

@onready var timer = $Timer
@export var NPC_types: Array[PackedScene]

@export var score_label: Label
var npc_count: int

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.score = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	score_label.text = "Score: " + str(Global.score)

func spawn_npc():
	var new_npc = NPC_types.pick_random().instantiate()
	new_npc.death.connect(_on_npc_death)
	npc_count += 1
	add_sibling(new_npc)

func _on_npc_death():
	npc_count -= 1

func _on_timer_timeout():
	spawn_npc()
	timer.start()
