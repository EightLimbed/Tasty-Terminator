extends Control

@onready var game = preload("res://Game/Game.tscn").instantiate()
var characters : Array[Character] = [preload("res://Player/Characters/Resources/Cookie.tres"), preload("res://Player/Characters/Resources/GummyBear.tres")]
var c_index : int = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func select_town():
	game.world_profile = load("res://World/Resources/Rural.tres")
	#game.world_profile = load("res://World/Resources/Desert.tres")

func start():
	get_tree().root.add_child(game)
	queue_free()

func character_left():
	if characters.size()-1 > c_index:
		c_index += 1
	else:
		c_index = 0

func character_right():
	if 0 < c_index:
		c_index -= 1
	else:
		c_index = characters.size()-1


func _on_temp_start_pressed() -> void:
	game.character_profile = characters[c_index]
	game.world_profile = load("res://World/Resources/Rural.tres")
	get_tree().root.add_child(game)
	queue_free()


func _on_temp_right_pressed() -> void:
	character_right()
