extends Control

@onready var game = preload("res://Game/Game.tscn").instantiate()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game.world_profile = load("res://World/Resources/NewYork.tres")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_play_pressed() -> void:
	get_tree().root.add_child(game)
	queue_free()
