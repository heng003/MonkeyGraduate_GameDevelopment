extends CharacterBody2D

@export var move_speed : float = 60.0
@export var chase_speed: float = 120.0
@export var path_string: String   # Now editable in the editor

@onready var sprite : AnimatedSprite2D = $Sprite2D
@onready var chase_area : Area2D = $ChaseArea
@onready var path: Path2D = get_parent().get_node(path_string)
@onready var path_follow: PathFollow2D = path.get_node("PathFollow2D")

var direction := 1.0
var last_position: Vector2
var is_chasing_mode := false
var target: CharacterBody2D = null 
var is_returning_to_patrol_path := false
var last_patrol_position : Vector2
var chasing_limit_distance := 500

func _ready():
		position = path_follow.global_position
		last_position = position
		
		if chase_area:
			chase_area.player_entered_area.connect(_on_player_entered_area)
			chase_area.player_exited_area.connect(_on_player_exited_area)

func _on_player_entered_area(body):
	target = body
	is_returning_to_patrol_path = false
	is_chasing_mode = true
	last_patrol_position = path_follow.global_position
	
func _on_player_exited_area(body):
	if target == body:
		target = null
		is_chasing_mode = false
		is_returning_to_patrol_path = true
		
func _physics_process(delta: float) -> void:
	if is_chasing_mode:
		chase_target(delta)
	elif is_returning_to_patrol_path :
		returning_to_patrol_path(delta)
	else :
		patrol_path(delta)
		
	update_animation()

		
func patrol_path(delta: float) -> void : 
	path_follow.progress += move_speed * delta * direction
	
	# Reverse direction at path ends
	if(path_follow.progress_ratio >= 1.0):
		direction = -1.0
	elif(path_follow.progress_ratio <= 0.0):
		direction = 1.0
		
	position = path_follow.global_position	

func chase_target(delta: float) -> void : 
	var distance_from_path = global_position.distance_to(path_follow.global_position)
	if distance_from_path > chasing_limit_distance:  # Chasing limit
		is_chasing_mode = false
		is_returning_to_patrol_path = true
		return	
	var dir = (target.global_position - global_position).normalized()
	print("direction: ", dir)
	velocity = dir * chase_speed
	move_and_slide()
	
func returning_to_patrol_path(delta: float) -> void : 
	var dir = (last_patrol_position - global_position).normalized()
	velocity = dir * chase_speed
	move_and_slide()
	
	if global_position.distance_to(last_patrol_position) < 5.0 : 
		is_returning_to_patrol_path = false
		position = last_patrol_position
	
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
