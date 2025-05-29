extends Area2D

@onready var player = null
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var is_collected = false
var follow_offset = Vector2(120,50)
var follow_delay = 0.10  # seconds of delay
var follow_positions: Array[Vector2] = []

func _ready():
	body_entered.connect(_on_body_entered)
	animated_sprite_2d.play()

func _on_body_entered(body: Node):
	if body.name == "Monyet":  
		player = body
		is_collected = true
		$CollisionShape2D.disabled = true

func _process(delta):
	if is_collected and player:
		follow_positions.append(player.global_position + follow_offset)

		if follow_positions.size() > int(follow_delay / delta):
			global_position = follow_positions.pop_front()
