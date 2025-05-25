extends CharacterBody2D

const SPEED = 300

@onready var sprite_2d: AnimatedSprite2D = $Sprite2D
var last_direction: String = "front"  # default direction
var can_move: bool = true  

func _physics_process(_delta):
	sprite_2d.play()
	if not can_move:
		velocity = Vector2.ZERO
		move_and_slide()
		play_idle_animation()
		return

	var input_vector = Vector2.ZERO

	if Input.is_action_pressed("ui_up"):
		input_vector.y = -1
	elif Input.is_action_pressed("ui_down"):
		input_vector.y = 1
	elif Input.is_action_pressed("ui_left"):
		input_vector.x = -1
	elif Input.is_action_pressed("ui_right"):
		input_vector.x = 1

	if input_vector.x != 0:
		input_vector.y = 0  # Enforce 4-direction movement only

	velocity = input_vector.normalized() * SPEED
	move_and_slide()

	if input_vector == Vector2.ZERO:
		play_idle_animation()
	else:
		play_walk_animation(input_vector)

func play_idle_animation():
	match last_direction:
		"front":
			sprite_2d.animation = "front_idle"
		"back":
			sprite_2d.animation = "back_idle"
		"right":
			sprite_2d.animation = "right_idle"
			sprite_2d.flip_h = false
		"left":
			sprite_2d.animation = "right_idle"
			sprite_2d.flip_h = true

func play_walk_animation(input_vector: Vector2):
	if input_vector.y == -1:
		sprite_2d.animation = "back_walk"
		sprite_2d.flip_h = false
		last_direction = "back"
	elif input_vector.y == 1:
		sprite_2d.animation = "front_walk"
		sprite_2d.flip_h = false
		last_direction = "front"
	elif input_vector.x == 1:
		sprite_2d.animation = "right_walk"
		sprite_2d.flip_h = false
		last_direction = "right"
	elif input_vector.x == -1:
		sprite_2d.animation = "right_walk"
		sprite_2d.flip_h = true
		last_direction = "left"
