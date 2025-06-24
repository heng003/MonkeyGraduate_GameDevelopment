extends CanvasLayer

signal retry_pressed
signal back_pressed

@onready var retry_button = $Panel/VBoxContainer/HBoxContainer/RetryButton
@onready var back_button = $Panel/VBoxContainer/HBoxContainer/BackButton


func _ready():
	retry_button.pressed.connect(emit_retry)
	back_button.pressed.connect(emit_back)

func emit_retry():
	var root = get_tree().current_scene
	var monyet = root.get_node("Monyet")

	if root.has_node("LakeStartMarker"):
		monyet.global_position = root.get_node("LakeStartMarker").global_position
	elif root.has_node("Game1StartMarker"):
		monyet.global_position = root.get_node("Game1StartMarker").global_position

	monyet.can_move = true
	emit_signal("retry_pressed")
	visible = false


func emit_back():
	var root_node = get_tree().current_scene

	if(root_node.has_method("_on_player_select")):
		root_node._on_player_select()
	emit_signal("back_pressed")
	visible = false
