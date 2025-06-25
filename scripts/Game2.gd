extends Node2D

@onready var dialogue_manager = $DialogueManager
@onready var player = $Monyet
@onready var book_popup = $BookPopup
@onready var game2_bgm = $Game2Bgm
@onready var flipping_book_sound_effect = $FlippingBookSoundEffect

var entry_dialogue_path = "Game2Entry.json"
var quiz_dialogue_path = "Game2Quiz.json"

var correct_streak := 0

func _ready():
	book_popup.popup_closed.connect(Callable(self, "_on_popup_closed"))
	
	dialogue_manager.connect("correct_answer", Callable(self, "_on_quiz_correct"))
	dialogue_manager.connect("wrong_answer",   Callable(self, "_on_quiz_wrong"))
	
	_play_dialogue(entry_dialogue_path)
	$FadeLayer.visible = true
	$FadeLayer/AnimationPlayer.play("fade_in")
	$FadeLayer/AnimationPlayer.animation_finished.connect(Callable(self, "_on_fade_in_finished"))

func _on_fade_in_finished(anim_name: String) -> void:
	if anim_name == "fade_in":
		$FadeLayer.visible = false

func trigger_library_quiz():
	_play_dialogue(quiz_dialogue_path)

func _play_dialogue(dialogue_path: String) -> void:
	player.can_move = false
	dialogue_manager.visible = true
	dialogue_manager.start_dialogue(dialogue_path)
	
	if dialogue_manager.dialogue_finished.is_connected(_on_dialogue_finished):
		dialogue_manager.dialogue_finished.disconnect(_on_dialogue_finished)
	dialogue_manager.dialogue_finished.connect(_on_dialogue_finished)

	if dialogue_manager.quiz_finished.is_connected(_on_all_quizzes_correct) == false:
		dialogue_manager.quiz_finished.connect(_on_all_quizzes_correct)


func _on_dialogue_finished():
	player.can_move = true

func _show_um_info(left_title: String, left_desc: String, right_title: String, right_detail: String):
	player.can_move = false
	game2_bgm.stop()
	flipping_book_sound_effect.play()
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
	game2_bgm.play()
	
func exit_to_main_map():
	player.can_move = false
	dialogue_manager.visible = true
	dialogue_manager.start_dialogue("MainMapGame2Exit.json")

	if dialogue_manager.dialogue_finished.is_connected(_on_exit_dialogue_finished):
		dialogue_manager.dialogue_finished.disconnect(_on_exit_dialogue_finished)

	dialogue_manager.dialogue_finished.connect(_on_exit_dialogue_finished)

func _on_exit_dialogue_finished():
	dialogue_manager.dialogue_finished.disconnect(_on_exit_dialogue_finished)

	$FadeLayer.visible = true
	$FadeLayer/AnimationPlayer.play("fade_out")
	await $FadeLayer/AnimationPlayer.animation_finished

	GameManager.current_level = max(GameManager.current_level, 2)
	print("Marking Game 2 as completed.")
	GameManager.has_completed_game2 = true
	GameManager.returning_from_game2 = true
	GameManager.return_point = "game2"
	get_tree().change_scene_to_file("res://scenes/MainMap.tscn")
	
func _on_quiz_correct():
	correct_streak += 1
	print("Streak: ", correct_streak)

func _on_quiz_wrong():
	correct_streak = 0
	print("Streak reset")			

func _on_all_quizzes_correct() -> void:
	dialogue_manager.disconnect("correct_answer", Callable(self, "_on_quiz_correct"))
	dialogue_manager.disconnect("wrong_answer",   Callable(self, "_on_quiz_wrong"))
	dialogue_manager.quiz_finished.disconnect(_on_all_quizzes_correct)
	
	GameManager.has_completed_game2 = true
	GameManager.current_level = max(GameManager.current_level, 2)
	GameManager.return_point = "game2" 
	
	$FadeLayer.visible = true
	$FadeLayer/AnimationPlayer.play("fade_out")
	await $FadeLayer/AnimationPlayer.animation_finished
	
	get_tree().change_scene_to_file("res://scenes/MainMap.tscn")
