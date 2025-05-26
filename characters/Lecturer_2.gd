#readme
#CHANGE the code
#now the code of lecturer1 is: player can control
#change to make lecturer move in constant path, and chase user after noticing user
#lecturer's walking speed is slower than monyet


extends CharacterBody2D

@onready var sprite_2d: AnimatedSprite2D = $Sprite2D

const SPEED = 200

var last_direction := "down"  # Possible values: "up", "down", "left", "right"

func _physics_process(_delta):
	var direction = Vector2.ZERO

	# Input detection
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1
		last_direction = "up"
	elif Input.is_action_pressed("ui_down"):
		direction.y += 1
		last_direction = "down"

	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
		last_direction = "left"
	elif Input.is_action_pressed("ui_right"):
		direction.x += 1
		last_direction = "right"

	# Cancel diagonal movement (keep only horizontal or vertical)
	if direction.x != 0:
		direction.y = 0

	# Movement logic
	if direction != Vector2.ZERO:
		velocity = direction.normalized() * SPEED
	else:
		velocity = Vector2.ZERO

	move_and_slide()

	# Animation logic
	if velocity != Vector2.ZERO:
		match last_direction:
			"up":
				sprite_2d.flip_h = false
				sprite_2d.play("back_walk")
			"down":
				sprite_2d.flip_h = false
				sprite_2d.play("front_walk")
			"right":
				sprite_2d.flip_h = false
				sprite_2d.play("right_walk")
			"left":
				sprite_2d.flip_h = true
				sprite_2d.play("right_walk")
	else:
		match last_direction:
			"up":
				sprite_2d.flip_h = false
				sprite_2d.play("back_idle")
			"down":
				sprite_2d.flip_h = false
				sprite_2d.play("front_idle")
			"right":
				sprite_2d.flip_h = false
				sprite_2d.play("right_idle")
			"left":
				sprite_2d.flip_h = true
				sprite_2d.play("right_idle")
