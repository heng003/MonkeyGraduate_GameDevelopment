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
	pass
