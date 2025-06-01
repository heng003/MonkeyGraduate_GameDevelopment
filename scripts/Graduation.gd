extends Node2D

@onready var dialogue_manager = $DialogueManager
@onready var player = $Monyet

var entry_dialogue_path = "GraduationEntry.json"
var ending_dialogue_path = "GraduationEnd.json"

func _ready():
	_play_dialogue(entry_dialogue_path)

func trigger_ending_dialogue():
	_play_dialogue(ending_dialogue_path)

func _play_dialogue(dialogue_path: String) -> void:
	player.can_move = false
	dialogue_manager.visible = true
	dialogue_manager.start_dialogue(dialogue_path)
	dialogue_manager.dialogue_finished.connect(_on_dialogue_finished)

func _on_dialogue_finished():
	player.can_move = true

func show_replay_popup():
	var replay_popup = preload("res://ui/PlayAgainPopUp.tscn").instantiate()
	add_child(replay_popup)
	replay_popup.replay_pressed.connect(_on_replay_pressed)
	replay_popup.quit_pressed.connect(_on_quit_pressed)
	replay_popup.visible = true

func _on_replay_pressed():
	print("Replay pressed!")
	# Restart level or reset logic here

func _on_quit_pressed():
	print("Quit pressed!")
		# Quit game
