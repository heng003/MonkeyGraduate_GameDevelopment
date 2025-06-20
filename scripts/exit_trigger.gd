extends Area2D

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	if body.name == "Monyet":
		if get_parent().keys_collected >= get_parent().total_keys:
			get_parent().exit_to_main_map()
