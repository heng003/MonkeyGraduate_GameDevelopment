extends CharacterBody2D


const SPEED = 250
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D
var last_direction: String = "front"  # default direction
var can_move: bool = true  # ← Add this line
var is_in_lake: bool = false
var is_on_bridge: bool = false
var bridge_area: Area2D = null
var lake_area: Area2D = null
@onready var fall_into_lake_sound: AudioStreamPlayer = $'../SoundFallIntoLake'


func _ready():    
	if get_parent().has_node("BridgeArea"):
		bridge_area = get_node("../BridgeArea")
		bridge_area.body_entered.connect(_on_BridgeArea_body_entered)
		bridge_area.body_exited.connect(_on_BridgeArea_body_exited)

	if get_parent().has_node("LakeArea"):
		lake_area = get_node("../LakeArea")
		lake_area.body_entered.connect(_on_LakeArea_body_entered)
		lake_area.body_exited.connect(_on_LakeArea_body_exited)

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
		
func trigger_fall():
	fall_into_lake_sound.play()
	can_move = false
	print("Fell into lake")

	var retry_popup = get_parent().get_node("RetryPopUp")# Adjust if needed
	retry_popup.visible = true
	
func _on_BridgeArea_body_entered(body):
	if body == self :
		is_on_bridge = true

func _on_BridgeArea_body_exited(body):
	if body == self :
		is_on_bridge = false
		if(is_in_lake):
			trigger_fall()
			
func _on_LakeArea_body_entered(body):
	if body == self :
		is_in_lake = true
		if(not is_on_bridge):
			trigger_fall()
			
func _on_LakeArea_body_exited(body):
	if body == self :
		is_in_lake = false
