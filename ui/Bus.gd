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
@onready var node_2d: Node2D = $".."

var direction := 1.0
var last_position: Vector2

func _ready():
	body_entered.connect(_on_body_entered)
	position = path_follow.global_position
	last_position = position
		
func _physics_process(_delta: float) -> void:
	if path_follow.progress_ratio < 0.7:
		path_follow.progress += move_speed * _delta
		sprite_2d.play()
	elif path_follow.progress_ratio < 1.0:
		path_follow.progress += slow_speed * _delta
		sprite_2d.play()
	else:
		sprite_2d.stop()
		#game_over()
		
	position = path_follow.global_position	
	
func _on_body_entered(body):
	if body.name == "Monyet":
		print("You chased the bus")
		
		sprite_2d.stop()
		sound_get_into_bus.play()
		monyet.visible = false
		await get_tree().create_timer(0.5).timeout

		set_physics_process(false)	
		get_tree().paused = true

		
func game_over():
	print(visible)
	sprite_2d.stop()
	bgm.stop()
	sound_missed_bus.play()
	await get_tree().create_timer(1).timeout
	set_physics_process(false)	
	get_tree().paused = true
	get_tree().current_scene.show_retry_popup()

	print("You missed the bus")
