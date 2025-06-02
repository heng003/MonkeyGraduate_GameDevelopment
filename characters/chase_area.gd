extends Area2D

signal player_entered_area(body)
signal player_exited_area(body)

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.name == "Monyet":
		emit_signal("player_entered_area", body)

func _on_body_exited(body):
	if body.name == "Monyet":
		emit_signal("player_exited_area", body)
