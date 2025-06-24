extends Node2D

@onready var dialogue_manager = $DialogueManager
@onready var player = $Monyet
@onready var fade_layer = $FadeLayer
var has_game_ended := false

var entry_dialogue_path = "Game4Entry.json"
var retry_dialogue_path = "Game4Retry.json"

func _ready():
	_play_dialogue(entry_dialogue_path)

	fade_layer.visible = true
	fade_layer.get_node("AnimationPlayer").play("fade_in")
	fade_layer.get_node("AnimationPlayer").animation_finished.connect(_on_fade_in_finished)

func _on_fade_in_finished(anim_name: String) -> void:
	if anim_name == "fade_in":
		fade_layer.visible = false

func trigger_retry_dialogue():
	_play_dialogue(retry_dialogue_path)

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
	retry_popup.visible = true

func _on_retry_pressed():
	print("Retry pressed!")
	trigger_retry_dialogue()
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_back_pressed():
	print("Back pressed!")
