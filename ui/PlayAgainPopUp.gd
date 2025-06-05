extends CanvasLayer

signal replay_pressed
signal quit_pressed

@onready var replay_button = $Panel/VBoxContainer/HBoxContainer/ReplayButton
@onready var quit_button = $Panel/VBoxContainer/HBoxContainer/QuitButton

func _ready():
	replay_button.pressed.connect(emit_replay)
	quit_button.pressed.connect(emit_quit)

func emit_replay():
	emit_signal("replay_pressed")
	visible = false

func emit_quit():
	emit_signal("quit_pressed")
	visible = false
