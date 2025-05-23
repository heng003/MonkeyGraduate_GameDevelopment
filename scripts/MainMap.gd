extends Node2D

@onready var dialogue_box = $CanvasLayer/DialogueBox
@onready var player = $Monyet 

var intro_dialogue = [
	{"name": "Monyet", "text": "Another year, still just… a monyet."},
	{"name": "Monyet", "text": "I've watched so many students walk these grounds... real UM students."},
	{"name": "Monyet", "text": "But this time, I’m ready."},
	{"name": "Monyet", "text": "To become one of them, I must face every challenge... and pass."},
	{"name": "Monyet", "text": "Let’s do this. My journey to graduate begins—now!"}
]

func _ready():
	player.can_move = false
	dialogue_box.start_dialogue(intro_dialogue)
	dialogue_box.dialogue_finished.connect(_on_dialogue_finished)

func _on_dialogue_finished():
	player.can_move = true
