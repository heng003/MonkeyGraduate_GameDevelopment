extends Area2D

@onready var dialogue_manager = get_parent().get_node("DialogueManager")
var player_ref  # to store the player node temporarily

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.name == "Monyet":
		player_ref = body  # Store reference
		player_ref.can_move = false
		dialogue_manager.start_dialogue("Game3Exit.json")
		dialogue_manager.dialogue_finished.connect(_on_dialogue_finished)

func _on_dialogue_finished():
	GameManager.has_completed_game3 = true
	dialogue_manager.dialogue_finished.disconnect(_on_dialogue_finished)

	if player_ref:
		player_ref.can_move = true
