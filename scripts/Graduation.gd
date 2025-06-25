extends Node2D

@onready var dialogue_manager = $DialogueManager
@onready var player = $Monyet

var entry_dialogue_path = "GraduationEntry.json"
var ending_dialogue_path = "GraduationEnd.json"
var landing_scene_path = "res://scenes/Landing.tscn"
var main_map_scene_path = "res://scenes/MainMap.tscn"
var current_dialogue_path = ""

func _ready():
	$FadeLayer.visible = true
	var anim = $FadeLayer.get_node("AnimationPlayer")
	anim.play("fade_in")
	anim.animation_finished.connect(_on_fade_in_finished)

func trigger_ending_dialogue():
	_play_dialogue(ending_dialogue_path)

func _play_dialogue(dialogue_path: String) -> void:
	current_dialogue_path = dialogue_path  # Track current dialogue
	player.can_move = false
	dialogue_manager.visible = true
	dialogue_manager.start_dialogue(dialogue_path)

	if dialogue_manager.dialogue_finished.is_connected(_on_dialogue_finished):
		dialogue_manager.dialogue_finished.disconnect(_on_dialogue_finished)

	dialogue_manager.dialogue_finished.connect(_on_dialogue_finished)

func _on_dialogue_finished():
	player.can_move = true

	if current_dialogue_path == ending_dialogue_path:
		show_replay_popup()

func show_replay_popup():
	var replay_popup = preload("res://ui/PlayAgainPopUp.tscn").instantiate()
	add_child(replay_popup)
	replay_popup.replay_pressed.connect(_on_replay_pressed)
	replay_popup.quit_pressed.connect(_on_quit_pressed)
	replay_popup.visible = true

func _on_replay_pressed():
	print("Replay pressed! Resetting game...")
	GameManager.reset_game()
	await fade_and_switch_scene(main_map_scene_path)

func _on_quit_pressed():
	print("Quit pressed! Going to landing scene.")
	await fade_and_switch_scene(landing_scene_path)
		
func _on_fade_in_finished(anim_name: String) -> void:
	if anim_name == "fade_in":
		_play_dialogue(entry_dialogue_path)
		
func fade_and_switch_scene(scene_path: String) -> void:
	var anim = $FadeLayer.get_node("AnimationPlayer")
	$FadeLayer.visible = true
	anim.play("fade_out")
	await anim.animation_finished
	get_tree().change_scene_to_file(scene_path)
		
		
		
