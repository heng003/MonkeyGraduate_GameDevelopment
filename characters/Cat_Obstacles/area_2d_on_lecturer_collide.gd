extends Area2D

@export var dialogue_path: String = ""  # Now editable in the editor

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node):
	if body.name == "Monyet":
		body.set_physics_process(false)
		get_tree().paused = true
		
		var root_node = get_tree().current_scene
		var sound_game_over = root_node.get_node("GameOverSound")
		var sound_waiting_player_response = root_node.get_node("WaitingResponseSound")

		sound_game_over.play()
		await sound_game_over.finished
		sound_waiting_player_response.play()

		if root_node.has_method("_play_dialogue"):
			root_node._play_dialogue(dialogue_path)
			await root_node.dialogue_manager.dialogue_finished
		
		if root_node.has_method("show_retry_popup"):
			root_node.show_retry_popup()			
