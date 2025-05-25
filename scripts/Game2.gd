extends Node2D

@onready var dialogue_manager = $DialogueManager
@onready var player = $Monyet

var entry_dialogue_path = "Game2Entry.json"
var quiz_dialogue_path = "Game2Quiz.json"

func _ready():
	_play_dialogue(entry_dialogue_path)

func trigger_library_quiz():
	_play_dialogue(quiz_dialogue_path)

func _play_dialogue(dialogue_path: String) -> void:
	player.can_move = false
	dialogue_manager.visible = true
	dialogue_manager.start_dialogue(dialogue_path)
	dialogue_manager.dialogue_finished.connect(_on_dialogue_finished)

func _on_dialogue_finished():
	player.can_move = true
