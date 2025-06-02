extends CollisionShape2D

func _ready():
	body_entered.connect(_on_body_entered)
	animated_sprite_2d.play()

func _on_body_entered(body: Node):
	if body.name == "Monyet":  
		player = body
		is_collected = true
		$CollisionShape2D.disabled = true

func _process(delta):
	pass
