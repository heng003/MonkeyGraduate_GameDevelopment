extends CanvasLayer

@onready var content_left_label = $Panel/ContentLeft
@onready var content_right_label = $Panel/ContentRight
@onready var close_button = $Panel/CloseButton
@onready var player_selection_sound_effect = $PlayerSelectionSoundEffect

signal popup_closed

func _ready():
	visible = false
	close_button.pressed.connect(hide_popup)

func show_popup(content_left: String, content_right: String):
	content_left_label.text = content_left
	content_right_label.text = content_right
	visible = true

func hide_popup():
	player_selection_sound_effect.play()
	visible = false
	emit_signal("popup_closed")
