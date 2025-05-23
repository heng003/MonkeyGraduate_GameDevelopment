extends Node

func go_to_scene(scene_path: String) -> void:
	var new_scene = load(scene_path).instantiate()
	get_tree().root.call_deferred("add_child", new_scene)

	# Remove current scene
	for child in get_tree().root.get_children():
		if child != new_scene:
			get_tree().root.remove_child(child)
