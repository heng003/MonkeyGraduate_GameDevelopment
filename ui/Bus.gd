extends Area2D

@export var move_speed : float = 150.0
@export var slow_speed : float = 120.0
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D
@onready var bus_route: Path2D = $"../BusRoute"
@onready var path_follow: PathFollow2D = bus_route.get_node("PathFollow2D")
@onready var sound_get_into_bus: AudioStreamPlayer = $"../SoundGetIntoBus"
@onready var monyet: CharacterBody2D = $"../Monyet"
@onready var sound_missed_bus: AudioStreamPlayer = $"../SoundMissedBus"
@onready var bgm: AudioStreamPlayer = $"../BGM"
@onready var fade_layer: CanvasLayer = $"../FadeLayer"
@onready var dialogue_manager = $"../DialogueManager"
@onready var success_marker = $"../BusStopMarker"
var has_game_ended := false
var is_game_over := false

var last_position: Vector2 = Vector2.ZERO

func _ready():
	is_game_over = false
	body_entered.connect(_on_body_entered)
	position = path_follow.global_position
	last_position = position

func _physics_process(_delta: float) -> void:
	if has_game_ended:
		return

	if path_follow.progress_ratio < 0.7:
		path_follow.progress += move_speed * _delta
		sprite_2d.play()
	elif path_follow.progress_ratio < 1.0:
		path_follow.progress += slow_speed * _delta
		sprite_2d.play()
	else:
		sprite_2d.stop()
		has_game_ended = true
		game_over()

	position = path_follow.global_position


func _on_body_entered(body):
	if is_game_over:
		return  # Ignore any interaction after game over

	if body.name == "Monyet":
		print("You chased the bus")

		sprite_2d.stop()
		sound_get_into_bus.play()
		monyet.visible = false
		await get_tree().create_timer(0.5).timeout

		# First fade out
		var anim = fade_layer.get_node("AnimationPlayer")
		fade_layer.visible = true
		anim.play("fade_out")
		await anim.animation_finished

		# Move to BusStopMarker position in Game4
		monyet.global_position = success_marker.global_position
		monyet.visible = true

		# Fade in
		anim.play("fade_in")
		await anim.animation_finished
		fade_layer.visible = false

		# Disable player movement and play exit dialogue
		monyet.can_move = false
		dialogue_manager.start_dialogue("MainMapGame4Exit.json")
		dialogue_manager.dialogue_finished.connect(_on_win_dialogue_finished)


func _on_win_dialogue_finished():
	# Disconnect first to prevent multiple triggers
	dialogue_manager.dialogue_finished.disconnect(_on_win_dialogue_finished)

	# Fade out again before scene change
	fade_layer.visible = true
	var anim = fade_layer.get_node("AnimationPlayer")
	anim.play("fade_out")
	await anim.animation_finished

	# Set return point and go to MainMap
	GameManager.has_completed_game4 = true
	GameManager.return_point = "game4"
	get_tree().change_scene_to_file("res://scenes/MainMap.tscn")

func game_over():
	print("You missed the bus")
	is_game_over = true
	sprite_2d.stop()
	bgm.stop()
	sound_missed_bus.play()

	# 1. Fade out
	var anim = fade_layer.get_node("AnimationPlayer")
	fade_layer.visible = true
	anim.play("fade_out")
	await anim.animation_finished

	# 2. Move player to BusStopMarker (like a "fail spot")
	monyet.global_position = success_marker.global_position
	monyet.visible = true

	# 3. Fade in
	anim.play("fade_in")
	await anim.animation_finished
	fade_layer.visible = false

	# 4. Let player move to Bus Driver manually
	monyet.can_move = true
