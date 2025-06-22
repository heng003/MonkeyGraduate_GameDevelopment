extends CanvasLayer

#----DATA (from file)-----#
var nodes
var current_id := -1
var current_name := ""
var current_text := ""
var current_next_id := -1
var current_choices := []
var is_random := false
var is_typing := false
var skip_typing := false

#------UI--------#
@onready var ui_panel = self
@onready var ui_text = $Panel/Dialogue
@onready var ui_name_text = $Panel/Name
@onready var ui_button_container= $Panel/Buttons
@onready var correct_answer_sound_effect = $CorrectAnswerSoundEffect
@onready var wrong_answer_sound_effect = $WrongAnswerSoundEffect

var ui_buttons = []

signal dialogue_finished
signal correct_answer
signal wrong_answer

func _ready():
	self.process_mode = Node.PROCESS_MODE_ALWAYS
	ui_buttons.append($Panel/Buttons/Button0)
	ui_buttons.append($Panel/Buttons/Button1)
	ui_buttons.append($Panel/Buttons/Button2)
	ui_buttons.append($Panel/Buttons/Button3)
	for button in ui_buttons:
		button.process_mode = Node.PROCESS_MODE_ALWAYS
		button.mouse_filter = Control.MOUSE_FILTER_PASS 
		button.focus_mode = Control.FOCUS_ALL
	
	seed(Time.get_unix_time_from_system())

	for button in ui_buttons:
		button.connect("mouse_entered", func(): print("Hovered:", button.name))
		button.connect("pressed", func(): print("Pressed:", button.name))

#-----Reading the File-----#
func load_json_file(fname):
	var path = "res://dialogue/" + fname
	if FileAccess.file_exists(path):
		var file = FileAccess.open(path, FileAccess.READ)
		var json = JSON.new()
		var parse_result = json.parse(file.get_as_text())
		
		if parse_result == OK:
			var json_result = json.get_data()
			is_random = bool(json_result.get("is_random", false))
			nodes = json_result.get("nodes", [])
			current_id = 0
		else:
			print("Dialogue: JSON Parse Error")
		
		file.close()
	else:
		print("Dialogue: File Open Error")
		print('filename:', fname)
		print("res://dialogue/" + fname)

#-----Traversing Graph-----#
func start_dialogue(fname):
	load_json_file(fname)
	
	if nodes and nodes.size() > 0:
		if is_random:
			var temp_ids = []
			for node in nodes:
				temp_ids.append(node["id"])
			current_id = temp_ids[randi() % temp_ids.size()]
		else:
			current_id = 0
		
		load_node(current_id)
	else:
		print("Dialogue: Could not find nodes or file is empty")

func end_dialogue():
	current_id = -1
	ui_panel.hide()
	emit_signal("dialogue_finished")

func _unhandled_input(event):
	if not ui_panel.visible:
		return

	if event is InputEventMouseButton or event.is_action_pressed("ui_accept"):
		if is_typing:
			skip_typing = true
		elif current_choices.size() == 0:
			load_node(current_next_id)

#----Load Node-----#
func load_node(id):
	current_id = id
	if current_id < 0 or not try_load_node(current_id):
		print("Could not load node with ID:", current_id)
		end_dialogue()
	else:
		update_ui()

func try_load_node(id):
	for node in nodes:
		if int(node.get("id", -1)) == id:
			current_name = node.get("name", "")
			current_text = node.get("text", "")
			current_next_id = int(node.get("next_id", -1))
			current_choices = node.get("choices", [])
			return true
	return false

#----Update UI-----#
func update_ui() -> void:
	ui_panel.show()
	ui_name_text.text = current_name

	# First, display the panel and name
	await typing_effect(current_text)  # Only call this once

	# Clear all existing button connections
	for button in ui_buttons:
		if button.pressed.is_connected(_on_choice_selected):
			button.pressed.disconnect(_on_choice_selected)
		if button.pressed.is_connected(load_node):
			button.pressed.disconnect(load_node)
	
	# Reset all buttons
	for button in ui_buttons:
		button.hide()
		button.disabled = false
		button.modulate = Color(1, 1, 1)  # Reset to white

	if current_choices.size() > 0:
		ui_button_container.show()
		for i in range(min(current_choices.size(), ui_buttons.size())):
			var choice = current_choices[i]
			var button = ui_buttons[i]
			
			button.text = choice.get("text", "Choice")
			button.show()
			
			# Connect with the correct parameters
			button.pressed.connect(_on_choice_selected.bind(choice), CONNECT_ONE_SHOT)
	else:
		# If no choices, show continue button
		ui_buttons[0].text = "Continue"
		ui_buttons[0].show()
		ui_buttons[0].pressed.connect(load_node.bind(current_next_id), CONNECT_ONE_SHOT)

func typing_effect(text: String) -> void:
	is_typing = true
	skip_typing = false
	ui_text.text = ""

	for i in text.length():
		if skip_typing:
			ui_text.text = text
			is_typing = false
			return  # Exit immediately when skipping
		ui_text.text = text.substr(0, i + 1)
		await get_tree().create_timer(0.03).timeout

	is_typing = false

func _on_choice_selected(choice: Dictionary) -> void:
	var root_node = get_tree().current_scene
	var quiz_bgm = root_node.get_node("QuizBgm") if root_node.has_node("QuizBgm") else null
	
	# Disable all buttons first
	for button in ui_buttons:
		button.disabled = true
	
	# Find which button was pressed
	var pressed_button = null
	for i in range(current_choices.size()):
		if i < ui_buttons.size() and current_choices[i] == choice:
			pressed_button = ui_buttons[i]
			break
	
	# Play appropriate sound effect
	var is_correct = choice.get("is_correct", false)
	if is_correct:
		correct_answer_sound_effect.play()
		emit_signal("correct_answer")
	else:
		if quiz_bgm:
			quiz_bgm.stop()
		wrong_answer_sound_effect.play()
		emit_signal("wrong_answer")
	
	# Visual feedback if we found the button
	if pressed_button:
		pressed_button.modulate = Color(0, 1, 0) if is_correct else Color(1, 0, 0)
	
	# Wait 1 second
	await get_tree().create_timer(1.0).timeout
	
	# Reset button colors
	for button in ui_buttons:
		button.modulate = Color(1, 1, 1)  # white (original)
	
	# Go to the next node
	load_node(choice.get("next_id", -1))
