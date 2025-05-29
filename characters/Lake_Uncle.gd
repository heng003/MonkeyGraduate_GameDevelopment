extends CharacterBody2D

@onready var sprite_2d: AnimatedSprite2D = $Sprite2D

func _physics_process(_delta: float) -> void:
	sprite_2d.play()
	velocity = Vector2.ZERO
	move_and_slide()
