extends Area2D

var entry_dialogue_path = "Game3Entry.json"

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node):
	if body.name == "Monyet":
		body.set_physics_process(false)
		get_tree().paused = true
		
		var root_node = get_tree().current_scene

		if root_node.has_method("_play_dialogue"):
			root_node._play_dialogue(entry_dialogue_path)
			await root_node.dialogue_manager.dialogue_finished
		
			get_tree().paused = false
			body.set_physics_process(true)
