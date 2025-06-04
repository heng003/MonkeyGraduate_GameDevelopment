extends Area2D

@export var trigger_method_name: String

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node):
	if body.name == "Monyet":		
		var root_node = get_tree().current_scene

		if root_node.has_method(trigger_method_name):
			root_node.call(trigger_method_name)
