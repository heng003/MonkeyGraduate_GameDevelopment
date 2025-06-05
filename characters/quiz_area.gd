extends Area2D

@export var dialogue_path: String = ""  # Now editable in the editor

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node):
	if body.name == "Monyet":
		body.set_physics_process(false)
		get_tree().paused = true
		
		var root_node = get_tree().current_scene
		var quiz_bgm = root_node.get_node("QuizBgm")
		var game2_bgm = root_node.get_node("Game2Bgm")
		var selection_sound_effect = root_node.get_node("PlayerSelectionSoundEffect")

		game2_bgm.stop()
		quiz_bgm.play()

		if root_node.has_method("_play_dialogue"):
			root_node._play_dialogue(dialogue_path)
			await root_node.dialogue_manager.dialogue_finished
		
			get_tree().paused = false
			body.set_physics_process(true)
			quiz_bgm.stop()
			game2_bgm.play()
