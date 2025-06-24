extends Area2D

@onready var dialogue_manager = $"../../DialogueManager"

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.name == "Monyet":
		body.can_move = false
		dialogue_manager.start_dialogue("Game4Retry.json")
		dialogue_manager.dialogue_finished.connect(_on_dialogue_finished)

func _on_dialogue_finished():
	dialogue_manager.dialogue_finished.disconnect(_on_dialogue_finished)
	get_tree().current_scene.show_retry_popup()
