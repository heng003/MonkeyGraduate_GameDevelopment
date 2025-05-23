extends Control  # or Panel

@onready var name_label = $NameLabel
@onready var dialogue_label = $DialogueLabel

var dialogue_lines = []
var current_line = 0
var dialogue_active = false
var is_skipping = false

signal dialogue_finished

func start_dialogue(lines: Array):
	dialogue_lines = lines
	current_line = 0
	dialogue_active = true
	visible = true
	show_line()

func show_line():
	if current_line >= dialogue_lines.size():
		end_dialogue()
		return

	var line = dialogue_lines[current_line]
	name_label.text = line["name"]
	
	var full_text = line["text"]
	dialogue_label.text = ""
	is_skipping = false
	
	await typing_effect(full_text)

func _unhandled_input(event):
	if not dialogue_active:
		return

	if event is InputEventMouseButton or event.is_action_pressed("ui_accept"):
		if is_skipping:
			current_line += 1
			show_line()
		else:
			is_skipping = true

func end_dialogue():
	dialogue_active = false
	visible = false
	emit_signal("dialogue_finished")

func typing_effect(text: String) -> void:
	for i in text.length():
		if is_skipping:
			dialogue_label.text = text
			break
		dialogue_label.text = text.substr(0, i + 1)
		await get_tree().create_timer(0.03).timeout
