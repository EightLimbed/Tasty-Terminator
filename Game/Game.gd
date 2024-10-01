extends Node2D

@onready var world = $World
@onready var player = $Player

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _process(_delta: float):
	world.generate_roads(player.position, Vector2i(24,24))
