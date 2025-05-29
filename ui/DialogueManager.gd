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
var ui_buttons = []

signal dialogue_finished

func _ready():
	ui_buttons.append($Panel/Buttons/Button0)
	ui_buttons.append($Panel/Buttons/Button1)
	ui_buttons.append($Panel/Buttons/Button2)
	ui_buttons.append($Panel/Buttons/Button3)
	# Seed random generator for random dialogues
	seed(Time.get_unix_time_from_system())

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
			print("nodes: ", nodes[0].text)
			current_id = 0
		else:
			print("Dialogue: JSON Parse Error")
		
		file.close()
	else:
		print("Dialogue: File Open Error")

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
		print("Calling update_ui for ID:", current_id)
		update_ui()

func try_load_node(id):
	for node in nodes:
		if int(node.get("id", -1)) == id:
			current_name = node.get("name", "")
			current_text = node.get("text", "")
			current_next_id = int(node.get("next_id", -1))
			current_choices = node.get("choices", [])
			print("Loaded node with ID:", id)
			return true
	return false

#----Update UI-----#
func update_ui() -> void:
	ui_panel.show()
	ui_name_text.text = current_name

	# First, display the panel and name
	await typing_effect(current_text)  # Only call this once

	# After typing is done or skipped, show choices/buttons
	for button in ui_buttons:
		button.hide()
		for connection in button.pressed.get_connections():
			button.pressed.disconnect(connection["callable"])

	if current_choices.size() > 0:
		for i in range(current_choices.size()):
			if i >= ui_buttons.size():
				break

			var choice = current_choices[i]
			ui_buttons[i].text = choice.get("text", "Choice")
			ui_buttons[i].show()

			# Clear existing signals
			for connection in ui_buttons[i].pressed.get_connections():
				ui_buttons[i].pressed.disconnect(connection["callable"])

			# Connect button with visual feedback logic
			ui_buttons[i].pressed.connect(Callable(self, "_on_choice_selected").bind(ui_buttons[i], choice))
		
		ui_button_container.show()
	#else:
		#ui_buttons[0].text = "Continue"
		#ui_buttons[0].pressed.connect(Callable(self, "load_node").bind(current_next_id))
		#ui_buttons[0].show()

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

func _on_choice_selected(clicked_button: Button, choice: Dictionary) -> void:
	for button in ui_buttons:
		if button != clicked_button:
			button.disabled = true
		else:
			button.disabled = true
			var is_correct = choice.get("is_correct", false)
			button.modulate = Color(0, 1, 0) if is_correct else Color(1, 0, 0)
	
	# Wait 1 second
	await get_tree().create_timer(1.0).timeout
	
	# Hide button container
	ui_button_container.hide()
	
	# Reset button
	clicked_button.modulate = Color(1, 1, 1)  # white (original)
	for button in ui_buttons:
		button.disabled = false
	
	# Go to the next node
	load_node(choice.get("next_id", -1))
