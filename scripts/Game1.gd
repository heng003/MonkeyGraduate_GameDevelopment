extends Node2D

@onready var dialogue_manager = $DialogueManager
@onready var player = $Monyet
@onready var sound_player_select = $PlayerSelectionSoundEffect

var entry_dialogue_path = "Game1Entry.json"
var exit_dialogue_path = "MainMapGame1Exit.json"
var lecturer1_dialogue_path = "Game1Lecturer1.json"
var lecturer2_dialogue_path = "Game1Lecturer2.json"
var total_keys = 2 
var keys_collected = 0

func _ready():
	$FadeLayer.visible = true
	$FadeLayer/AnimationPlayer.play("fade_in")
	_play_dialogue(entry_dialogue_path)

func _play_dialogue(dialogue_path: String) -> void:
	player.can_move = false
	dialogue_manager.visible = true
	dialogue_manager.start_dialogue(dialogue_path)
	dialogue_manager.dialogue_finished.connect(_on_dialogue_finished)

func _on_dialogue_finished():
	player.can_move = true
	
func _on_key_collected():
	keys_collected += 1
	
func _on_player_select():
	sound_player_select.play()
	
func show_retry_popup():
	var retry_popup = preload("res://ui/RetryPopup.tscn").instantiate()
	add_child(retry_popup)
	retry_popup.retry_pressed.connect(_on_retry_pressed)
	retry_popup.back_pressed.connect(_on_back_pressed)
	retry_popup.visible = true

func _on_retry_pressed():
	print("Retry pressed!")
	get_tree().paused = false  # Unpause before restarting
	var current_scene = get_tree().current_scene
	get_tree().reload_current_scene()
	# Restart level or reset logic here

func _on_back_pressed():
	print("Back pressed!")
	get_tree().paused = false
	GameManager.return_point = "game1"
	
	# Start fade out
	$FadeLayer.visible = true
	$FadeLayer/AnimationPlayer.play("fade_out")

	# Wait for fade out to complete before changing scene
	await $FadeLayer/AnimationPlayer.animation_finished

	get_tree().change_scene_to_file("res://scenes/MainMap.tscn")

func exit_to_main_map():
	player.can_move = false
	dialogue_manager.visible = true
	dialogue_manager.start_dialogue(exit_dialogue_path)

	# Prevent multiple connections
	if dialogue_manager.dialogue_finished.is_connected(_on_exit_dialogue_finished):
		dialogue_manager.dialogue_finished.disconnect(_on_exit_dialogue_finished)

	dialogue_manager.dialogue_finished.connect(_on_exit_dialogue_finished)

func _on_exit_dialogue_finished():
	dialogue_manager.dialogue_finished.disconnect(_on_exit_dialogue_finished)

	# Start fade out
	$FadeLayer.visible = true
	$FadeLayer/AnimationPlayer.play("fade_out")
	await $FadeLayer/AnimationPlayer.animation_finished

	# Save progress and switch scene
	GameManager.current_level = 1
	GameManager.has_completed_game1 = true 
	GameManager.return_point = "game1"
	get_tree().change_scene_to_file("res://scenes/MainMap.tscn")
