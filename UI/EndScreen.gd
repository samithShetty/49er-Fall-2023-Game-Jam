extends Control

@onready var score_label: Label = $ScoreLabel
@onready var message_label: RichTextLabel = $GameOver/Message
@export var gameover_messages : Array[String]

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	message_label.text = "[center][i]%s[/i][/center]" % gameover_messages.pick_random()
	score_label.text = "Score: " + str(Global.score)

func _input(event):
	if event.is_action("throw"):
		Global.start_game()
