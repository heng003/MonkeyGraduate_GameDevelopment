extends Area2D

@export var bridge_tilemap: TileMap  # Drag your TileMap here
@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var disappear_timer: Timer = $DisappearTimer
@export var bridge_collision: CollisionPolygon2D  # Collision component

var active_bridge_tiles = []  # Tracks which bridge tiles should stay visible

func _ready():
	bridge_tilemap.visible = false  # Initially hidden
	bridge_collision.disabled = false  # Start with collision disabled
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	disappear_timer.timeout.connect(_on_disappear_timer_timeout)

func _on_body_entered(body):
	if body.name == "Monyet":
		anim_sprite.play("Pressed")

		if disappear_timer.is_stopped() == false:
			disappear_timer.stop()
			
		bridge_tilemap.visible = true
		bridge_collision.disabled = false  # 🛠️ RE-ENABLE COLLISION HERE

func _on_body_exited(body):
	if body.name == "Monyet":
		anim_sprite.stop()
		anim_sprite.frame = 0
		anim_sprite.play("Idle")
		# Only hide the bridge if no tiles are active
		#if active_bridge_tiles.is_empty():
		#bridge_tilemap.visible = false
		disappear_timer.start()

func _on_disappear_timer_timeout():
	# This runs when the timer completes (after 10 seconds)
	bridge_tilemap.visible = false
	bridge_collision.disabled = true
## Call this from the player script when standing on bridge tiles
#func add_active_bridge_tile(tile_position: Vector2):
	#if not active_bridge_tiles.has(tile_position):
		#active_bridge_tiles.append(tile_position)
		#bridge_tilemap.visible = true
#
## Call this from the player script when leaving bridge tiles
#func remove_active_bridge_tile(tile_position: Vector2):
	#active_bridge_tiles.erase(tile_position)
	#if active_bridge_tiles.is_empty() and not has_overlapping_bodies():
		#bridge_tilemap.visible = false
