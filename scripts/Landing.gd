extends Node2D

@onready var start_button = $StartButton
@onready var fade_layer = $FadeLayer

func _ready():
	print("Landing.gd ready")
	print("StartButton found:", start_button)
	start_button.pressed.connect(_on_start_pressed)

func _on_start_pressed():
	print("Start button pressed! Starting game...")
	GameManager.reset_game()
	await fade_and_switch_scene("res://scenes/MainMap.tscn")

func fade_and_switch_scene(scene_path: String) -> void:
	var anim = fade_layer.get_node("AnimationPlayer")
	fade_layer.visible = true
	anim.play("fade_out")
	await anim.animation_finished
	get_tree().change_scene_to_file(scene_path)
