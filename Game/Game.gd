extends Node2D

@onready var world = $World
@onready var player = $Player
var enemy = preload("res://Enemies/Enemy.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _process(_delta: float):
	world.generate_roads(player.position, Vector2i(24,24))

func spawn_enemies(amount, difficulty):
	for i in amount:
		var instance = enemy.instantiate()
