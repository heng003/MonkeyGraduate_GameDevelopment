extends Node2D

@onready var dialogue_manager = $DialogueManager
@onready var player = $Monyet
@onready var book_popup = $BookPopup

var entry_dialogue_path = "Game2Entry.json"
var quiz_dialogue_path = "Game2Quiz.json"

func _ready():
	book_popup.popup_closed.connect(_on_popup_closed)
	_play_dialogue(entry_dialogue_path)

func trigger_library_quiz():
	_play_dialogue(quiz_dialogue_path)

func _play_dialogue(dialogue_path: String) -> void:
	player.can_move = false
	dialogue_manager.visible = true
	dialogue_manager.start_dialogue(dialogue_path)
	dialogue_manager.dialogue_finished.connect(_on_dialogue_finished)

func _on_dialogue_finished():
	player.can_move = true

func _show_um_info(left_title: String, left_desc: String, right_title: String, right_detail: String):
	player.can_move = false
	var left_text = "%s\n\n%s" % [left_title, left_desc]
	var right_text = "%s\n\n%s" % [right_title, right_detail]
	book_popup.show_popup(left_text, right_text)

func show_um_history():
	_show_um_info(
		"UM Establishment",
		"Universiti Malaya (UM) was established in the year 1949, making it the oldest university in Malaysia.",
		"Historical Background",
		"UM was originally formed through the merger of King Edward VII College of Medicine and Raffles College in Singapore before moving to Kuala Lumpur."
	)

func show_um_library():
	_show_um_info(
		"Central Library",
		"UM’s central library, officially known as the **Central Library**, was established in 1959 and is located at the heart of the campus.",
		"Library Details",
		"It serves as the university’s main resource hub, providing access to millions of books, journals, theses, and digital resources for students, researchers, and academic staff."
	)

func show_um_motto():
	_show_um_info(
		"UM’s Motto",
		"The official motto of Universiti Malaya is **“Ilmu Punca Kemajuan”**, which translates to “Knowledge is the Source of Progress.”",
		"Motto Meaning",
		"This reflects UM’s commitment to excellence in education and its role in national development through knowledge."
	)

func _on_popup_closed():
	player.can_move = true
