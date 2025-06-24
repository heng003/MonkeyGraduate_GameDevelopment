extends Area2D

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.name == "Monyet":
		var root = get_tree().current_scene
		if root.has_method("trigger_game4_entry_dialogue"):
			root.trigger_game4_entry_dialogue()
