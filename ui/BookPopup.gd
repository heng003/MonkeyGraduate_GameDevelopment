extends CanvasLayer

@onready var content_left_label = $Panel/ContentLeft
@onready var content_right_label = $Panel/ContentRight
@onready var close_button = $Panel/CloseButton
@onready var player_selection_sound_effect = $PlayerSelectionSoundEffect

signal popup_closed

func _ready():
	visible = false
	layer = 100
	$Panel.mouse_filter = Control.MOUSE_FILTER_STOP
	close_button.mouse_filter = Control.MOUSE_FILTER_STOP
	if close_button:
		close_button.pressed.connect(hide_popup)

func show_popup(content_left: String, content_right: String):
	content_left_label.text = content_left
	content_right_label.text = content_right   
	visible = true

func hide_popup():
	print("Hide popup called")
	player_selection_sound_effect.play()
	visible = false
	set_process(false)
	emit_signal("popup_closed")
	
func _input(event):
	if event is InputEventMouseButton and event.pressed:
		print("Mouse click at: ", event.position)
