extends Node2D

@onready var player = $Monyet
@onready var book_popup = $BookPopup

#var books_content = {
	#"Placeholder1": {
		#"left": "UM was established in 1962, making it one of Malaysia's oldest universities.",
		#"right": "UM has 13 faculties including Engineering, Law, Medicine, and more."
	#},
	#"Placeholder2": {
		#"left": "UM’s main campus is located in Kuala Lumpur with beautiful green spaces.",
		#"right": "The university offers undergraduate, postgraduate, and doctoral programs."
	#},
	#"Placeholder3": {
		#"left": "UM is known for its strong research in science and technology.",
		#"right": "Many successful alumni have graduated from UM, making an impact worldwide."
	#}
#}

func _ready():
	pass

func _on_book_popup_closed() -> void:
	player.can_move = true
