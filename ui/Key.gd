extends Area2D

@onready var player = null
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var sound_key_collected: AudioStreamPlayer = $AudioStreamPlayer

var is_collected = false
var follow_offset = Vector2(120,50)
var follow_delay = 0.10  # seconds of delay
var follow_positions: Array[Vector2] = []

func _ready():
	body_entered.connect(_on_body_entered)
	animated_sprite_2d.play()

func _on_body_entered(body: Node):
	if is_collected: 
		return
	if body.name == "Monyet":  
		var root_node = get_tree().current_scene
		player = body
		is_collected = true
		sound_key_collected.play()
		root_node._on_key_collected()
		
		if root_node.keys_collected == 1: 
			animated_sprite_2d.modulate = Color(1, 1, 1, 0.5)  # Half transparent (dim)
		elif root_node.keys_collected == 2:
			animated_sprite_2d.modulate = Color(1, 1, 1)

		$CollisionShape2D.disabled = true

func _process(delta):
	if is_collected and player:
		follow_positions.append(player.global_position + follow_offset)

		if follow_positions.size() > int(follow_delay / delta):
			global_position = follow_positions.pop_front()
