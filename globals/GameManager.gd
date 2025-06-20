extends Node

var current_level = 0
var retry_count = 0
var has_graduated = false
var return_point = ""  # "game1", "game2"
var has_seen_mainmap_entry = false
var has_completed_game1 = false

func reset_game():
	current_level = 0
	retry_count = 0
	has_graduated = false
	return_point = ""
	has_seen_mainmap_entry = false
	has_completed_game1 = false
