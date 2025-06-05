extends PathFollow2D

var speed := 0.1
var direction := 1.0 # Forward: 1 , Backward: -1
@export var sprite_node_path: NodePath  # Editable in the editor
var last_position := Vector2.ZERO
var sprite: AnimatedSprite2D

func _ready():
	last_position = position
	if sprite_node_path != null:
		sprite = get_node(sprite_node_path).get_node("Sprite2D")

func _process(delta):
	progress_ratio += speed * direction * delta
	
	# Reverse direction at path ends
	if(progress_ratio >= 1.0):
		progress_ratio = 1.0
		direction = -1.0
	elif(progress_ratio <= 0.0):
		progress_ratio = 0.0
		direction = 1.0
	
	update_animation()
	
func update_animation():
	# Detect direction of movement
	var delta_pos = position - last_position
	last_position = position
	
	# Change animation based on direction
	if abs(delta_pos.x) > abs(delta_pos.y):
		if delta_pos.x > 0:
			sprite.animation = "right_walk"
			sprite.flip_h = false
		elif delta_pos.x < 0:
			sprite.animation = "right_walk"
			sprite.flip_h = true
	else:
		if delta_pos.y > 0:
			sprite.animation = "front_walk"
		elif delta_pos.y < 0: 
			sprite.animation = "back_walk"

	sprite.play()
	
	
	
