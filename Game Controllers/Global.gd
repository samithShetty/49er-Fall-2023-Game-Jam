extends Node
var score: int 

@onready var game_scene: PackedScene = preload("res://Scenes/Main.tscn")
@export var death_scene: PackedScene = preload("res://Scenes/EndScreen.tscn")

func _ready():
	AudioStream
	
func end_game():
	get_tree().change_scene_to_packed(death_scene)
	
func start_game():
	score = 0
	get_tree().change_scene_to_packed(game_scene)
