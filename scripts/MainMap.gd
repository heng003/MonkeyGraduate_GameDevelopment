extends Node2D

@onready var dialogue_manager = $DialogueManager
@onready var player = $Monyet 

var entry_dialogue_path = "MainMapEntry.json"
var game1_entry_dialogue_path = "MainMapGame1Enrty.json"
var game1_exit_dialogue_path = "MainMapGame1Exit.json"
var game2_entry_dialogue_path = "MainMapGame2Enrty.json"
var game2_exit_dialogue_path = "MainMapGame2Exit.json"

func _ready():
	_play_dialogue(entry_dialogue_path)

func trigger_game1_entry_dialogue():
	_play_dialogue(game1_entry_dialogue_path)

func trigger_game1_exit_dialogue():
	_play_dialogue(game1_exit_dialogue_path)

func trigger_game2_entry_dialogue():
	_play_dialogue(game2_entry_dialogue_path)

func trigger_game2_exit_dialogue():
	_play_dialogue(game2_exit_dialogue_path)

func _play_dialogue(dialogue_path: String) -> void:
	player.can_move = false
	dialogue_manager.visible = true
	dialogue_manager.start_dialogue(dialogue_path)
	dialogue_manager.dialogue_finished.connect(_on_dialogue_finished)

func _on_dialogue_finished():
	player.can_move = true
