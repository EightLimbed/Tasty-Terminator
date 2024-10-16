extends Control

@onready var game = preload("res://Game/Game.tscn").instantiate()
var characters : Array[Character] = [preload("res://Player/Characters/Resources/Cookie.tres"), preload("res://Player/Characters/Resources/GummyBear.tres")]
@onready var label = $Label
var c_index : int = 0
@onready var character_display = $TextureRect

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_town_pressed():
	game.world_profile = load("res://World/Resources/Town.tres")
	get_tree().root.add_child(game)
	queue_free()

func _on_desert_pressed():
	game.world_profile = load("res://World/Resources/Desert.tres")
	get_tree().root.add_child(game)
	queue_free()

func _on_left_character_pressed():
	if characters.size()-1 > c_index:
		c_index += 1
	else:
		c_index = 0
	label.text = characters[c_index].starting_weapon.name

func _on_right_character_pressed():
	if 0 < c_index:
		c_index -= 1
	else:
		c_index = characters.size()-1
	label.text = characters[c_index].starting_weapon.name
