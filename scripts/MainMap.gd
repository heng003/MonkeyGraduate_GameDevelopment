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
	
	if current_dialogue_path == game1_entry_dialogue_path:
		fade_and_switch_scene("res://scenes/Game1.tscn")
