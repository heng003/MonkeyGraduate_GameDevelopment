#readme
#change the code
#now the code of lecturer1 is player can control lecturer
#change to make lecturer move in constant path, and chase user after noticing user
#lecturer's walking speed is slower than monyet


extends CharacterBody2D

@onready var sprite_2d: AnimatedSprite2D = $Sprite2D

const SPEED = 150

var last_horizontal_direction: int = 1  # 1 = right, -1 = left

func _physics_process(_delta):
	var direction = Vector2.ZERO

	# Movement input
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1
	elif Input.is_action_pressed("ui_down"):
		direction.y += 1

	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
		last_horizontal_direction = -1
	elif Input.is_action_pressed("ui_right"):
		direction.x += 1
		last_horizontal_direction = 1

	# Movement logic
	if direction != Vector2.ZERO:
		direction = direction.normalized()
		velocity = direction * SPEED
	else:
		velocity = Vector2.ZERO

	move_and_slide()

	# Animation logic
	if direction.y < 0:
		sprite_2d.flip_h = false
		sprite_2d.play("back_walk")
	elif direction.y > 0:
		sprite_2d.flip_h = last_horizontal_direction == -1
		sprite_2d.play("right_walk")
	elif direction.x != 0:
		sprite_2d.flip_h = direction.x < 0
		sprite_2d.play("right_walk")
	else:
		# Idle state
		if Input.is_action_pressed("ui_up"):
			sprite_2d.flip_h = false
			sprite_2d.play("back_idle")
		elif Input.is_action_pressed("ui_down"):
			sprite_2d.flip_h = last_horizontal_direction == -1
			sprite_2d.play("right_idle")
		else:
			sprite_2d.flip_h = last_horizontal_direction == -1
			sprite_2d.play("right_idle")
