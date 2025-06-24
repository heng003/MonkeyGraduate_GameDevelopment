extends Node2D

@onready var dialogue_manager = $DialogueManager
@onready var player = $Monyet 

var entry_dialogue_path = "MainMapEntry.json"
var game1_entry_dialogue_path = "MainMapGame1Entry.json"
var game1_exit_dialogue_path = "MainMapGame1Exit.json"
var game2_entry_dialogue_path = "MainMapGame2Entry.json"
var game2_exit_dialogue_path = "MainMapGame2Exit.json"
var game4_entry_dialogue_path = "MainMapGame4Entry.json"
var game4_exit_dialogue_path = "MainMapGame4Exit.json"
var current_dialogue_path = ""

func _ready():
	if GameManager.return_point == "game1":
		player.global_position = $LectureHallExitMarker.global_position
	elif GameManager.return_point == "game2":
		player.global_position = $LibraryExitMarker.global_position
	elif not GameManager.has_seen_mainmap_entry:
		_play_dialogue(entry_dialogue_path)
		GameManager.has_seen_mainmap_entry = true

	player.get_node("Camera2D").make_current()
	player.can_move = true
	GameManager.return_point = "" # reset after use
	$FadeLayer.visible = true
	$FadeLayer/AnimationPlayer.play("fade_in")

func trigger_game1_entry_dialogue():
	if GameManager.has_completed_game1:
		print("Game 1 already completed. Entry blocked.")
		return  # Do nothing
	_play_dialogue(game1_entry_dialogue_path)

func trigger_game1_exit_dialogue():
	_play_dialogue(game1_exit_dialogue_path)

func trigger_game2_entry_dialogue():
	if GameManager.has_completed_game1:
		_play_dialogue(game2_entry_dialogue_path)

func trigger_game2_exit_dialogue():
	_play_dialogue(game2_exit_dialogue_path)
	
func trigger_game4_entry_dialogue():
	if GameManager.has_completed_game4:
		print("Game 4 already completed. Entry blocked.")
		return
	_play_dialogue(game4_entry_dialogue_path)	

func _play_dialogue(dialogue_path: String) -> void:
	current_dialogue_path = dialogue_path
	player.can_move = false
	dialogue_manager.visible = true
	dialogue_manager.start_dialogue(dialogue_path)
	
	if dialogue_manager.dialogue_finished.is_connected(_on_dialogue_finished):
		dialogue_manager.dialogue_finished.disconnect(_on_dialogue_finished)
		
	dialogue_manager.dialogue_finished.connect(_on_dialogue_finished)
	
func fade_and_switch_scene(target_scene: String) -> void:
	$FadeLayer.visible = true
	var anim = $FadeLayer.get_node("AnimationPlayer")
	anim.play("fade_out")

	await anim.animation_finished
	get_tree().change_scene_to_file(target_scene)

func _on_dialogue_finished():
	dialogue_manager.dialogue_finished.disconnect(_on_dialogue_finished)
	player.can_move = true
	
	match current_dialogue_path:
		game1_entry_dialogue_path:
			fade_and_switch_scene("res://scenes/Game1.tscn")
		game2_entry_dialogue_path:
			fade_and_switch_scene("res://scenes/Game2.tscn")
		game4_entry_dialogue_path:
			fade_and_switch_scene("res://scenes/Game4.tscn")
