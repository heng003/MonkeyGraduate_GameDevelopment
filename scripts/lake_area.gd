extends Area2D

@export var bridge_tilemap: TileMap  # Drag the bridge TileMap here

var bridge_positions := []  # Store tile positions that are bridge tiles

func _ready():
	body_entered.connect(_on_body_entered)
	
	# Scan the tilemap and store positions of bridge tiles
	for pos in bridge_tilemap.get_used_cells(0):  # layer 0
		var tile_data = bridge_tilemap.get_cell_tile_data(0, pos)
		if tile_data and tile_data.get_custom_data("type") == "bridge":
			bridge_positions.append(pos)

func _on_body_entered(body):
	if body.name == "Monyet":
		var tile_pos = bridge_tilemap.local_to_map(body.global_position)
		print("Character tile pos: ", tile_pos)
		print("bridge position: ", bridge_positions)
		if not bridge_positions.has(tile_pos):
			body.trigger_fall()
