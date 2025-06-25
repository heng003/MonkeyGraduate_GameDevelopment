extends Area2D

@export var fade_layer: CanvasLayer
@export var target_scene_path: String = "res://scenes/Graduation.tscn"

func _ready():
	print("GraduationTrigger ready")
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	print("Something entered GraduationTrigger:", body.name)
	
	if body.name == "Monyet":
		print("Monyet entered GraduationTrigger")
		
		if fade_layer:
			print("Fade layer found")

			if fade_layer.has_node("AnimationPlayer"):
				var anim = fade_layer.get_node("AnimationPlayer")
				print("Playing fade out animation")
				
				fade_layer.visible = true
				anim.play("fade_out")
				await anim.animation_finished
				print("Fade out done, switching to Graduation.tscn")
				get_tree().change_scene_to_file(target_scene_path)
			else:
				print("No AnimationPlayer found in fade_layer")
		else:
			print("fade_layer is null or not set")
