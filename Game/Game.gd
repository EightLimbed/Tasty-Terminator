extends Node2D

@onready var world = $World
@onready var player = $Player
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta: float):
	world.generate_roads(player.position, Vector2i(24,24), 1152)
