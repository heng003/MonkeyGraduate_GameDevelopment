extends Area2D

@export var dialogue_path: String = "MainMapGame3Enrty.js"  # Now editable in the editor

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node):
	if body.name == "Monyet":
		body.set_physics_process(false)
		get_tree().paused = true
		
		var root_node = get_tree().current_scene

		if root_node.has_method("_play_dialogue"):
			root_node._play_dialogue(dialogue_path)
			await root_node.dialogue_manager.dialogue_finished
		
			get_tree().paused = false
			body.set_physics_process(true)
