extends Node

@onready var timer = $Timer
@export var NPC_types: Array[PackedScene]

@export var score_label: Label
var npc_count: int

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	score_label.text = "Score: " + str(Global.score)

func spawn_npc():
	randomize()
	var new_npc = NPC_types.pick_random().instantiate()
	new_npc.position = Vector2(randi_range(-2000,2000), randi_range(-500, 275))
	new_npc.death.connect(_on_npc_death)
	npc_count += 1
	add_sibling(new_npc)

func _on_npc_death():
	npc_count -= 1

func _on_timer_timeout():
	if npc_count < 15:
		spawn_npc()
	timer.start()

func _on_audio_stream_player_2d_finished():
	$AudioStreamPlayer2D.play()
