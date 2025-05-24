extends Node2D

@onready var dialogue_box = $CanvasLayer/DialogueBox
@onready var player = $Monyet 

var intro_dialogue = [
	{"name": "Monyet", "text": "Alright… grab the keys, dodge the lecturers, find the exit."},
	{"name": "Monyet", "text": "Simple enough… right?"}
]

func _ready():
	player.can_move = false
	dialogue_box.visible = false
	await get_tree().create_timer(1.0).timeout 
	dialogue_box.visible = true 
	dialogue_box.start_dialogue(intro_dialogue)
	dialogue_box.dialogue_finished.connect(_on_dialogue_finished)

func _on_dialogue_finished():
	player.can_move = true
