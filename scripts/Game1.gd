extends Node2D

@onready var dialogue_manager = $DialogueManager
@onready var player = $Monyet

var entry_dialogue_path = "Game1Entry.json"
var lecturer1_dialogue_path = "Game1Lecturer1.json"
var lecturer2_dialogue_path = "Game1Lecturer2.json"

func _ready():
	_play_dialogue(entry_dialogue_path)

func trigger_lecturer1_dialogue():
	_play_dialogue(lecturer1_dialogue_path)

func trigger_lecturer2_dialogue():
	_play_dialogue(lecturer2_dialogue_path)

func _play_dialogue(dialogue_path: String) -> void:
	player.can_move = false
	dialogue_manager.visible = true
	dialogue_manager.start_dialogue(dialogue_path)
	dialogue_manager.dialogue_finished.connect(_on_dialogue_finished)

func _on_dialogue_finished():
	player.can_move = true

func show_retry_popup():
	var retry_popup = preload("res://ui/RetryPopup.tscn").instantiate()
	add_child(retry_popup)
	retry_popup.retry_pressed.connect(_on_retry_pressed)
	retry_popup.back_pressed.connect(_on_back_pressed)

func _on_retry_pressed():
	print("Retry pressed!")
	# Restart level or reset logic here

func _on_back_pressed():
	print("Back pressed!")
	# Go back to menu or previous screen
