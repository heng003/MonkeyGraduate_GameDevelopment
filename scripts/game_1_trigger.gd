extends Area2D

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	if body.name == "Monyet":  # Confirm your player node's name is exactly this
		get_parent().trigger_game1_entry_dialogue()
