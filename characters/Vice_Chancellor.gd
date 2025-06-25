extends CharacterBody2D

@onready var sprite_2d: AnimatedSprite2D = $Sprite2D
@onready var dialogue_trigger_area: Area2D = $DialogueTriggerArea

var dialogue_triggered := false

func _ready():
	dialogue_trigger_area.body_entered.connect(_on_body_entered)

func _physics_process(_delta: float) -> void:
	sprite_2d.play()
	velocity = Vector2.ZERO
	move_and_slide()

func _on_body_entered(body):
	if dialogue_triggered:
		return
		
	if body.name == "Monyet":
		dialogue_triggered = true
		print("Player approached Vice Chancellor – triggering GraduationEnd.json")
		get_parent().trigger_ending_dialogue()  # Call from Graduation.gd
