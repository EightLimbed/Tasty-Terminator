extends Control

@onready var game = preload("res://Game/Game.tscn").instantiate()
@onready var character_display = $VBoxContainer/CharacterSelect/Display
@onready var character_description = $VBoxContainer/CharacterDescription
@onready var character_description_label = $VBoxContainer/CharacterDescription/Label
@onready var character_name = $VBoxContainer/CharacterSelect/Display/Name
@onready var save_file = preload("res://Main Menu/Achievments/LocalAchievments.tres")
var characters : Array[Character] = [preload("res://Player/Characters/Resources/Cookie.tres")]
var c_index : int = 0

func _ready() -> void:
	save_file.verify_save()
	load_achievments()
	character_display.play()

#things that cannot be called by updates
func _process(_delta: float) -> void:
	character_description.custom_minimum_size.y = character_description_label.size.y

func load_achievments():
	if ResourceLoader.exists("user://save/AchievementLog.tres"):
		save_file = ResourceLoader.load("user://save/AchievementLog.tres")
	if save_file.achievments["Reach Level 100 (Unlocks Gummy Bear)"]:
		characters.append(load("res://Player/Characters/Resources/GummyBear.tres"))

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
	character_display.sprite_frames = characters[c_index].sprite_frames
	character_name.text = characters[c_index].name
	character_description_label.text = characters[c_index].description
	character_display.play()

func character_right():
	if 0 < c_index:
		c_index -= 1
	else:
		c_index = characters.size()-1
	character_display.sprite_frames = characters[c_index].sprite_frames
	character_name.text = characters[c_index].name
	character_description_label.text = characters[c_index].description
	character_display.play()

func _on_temp_start_pressed() -> void:
	game.character_profile = characters[c_index]
	game.world_profile = load("res://World/Resources/Rural.tres")
	get_tree().root.add_child(game)
	queue_free()

func _on_temp_left_character_pressed():
	character_left()

func _on_temp_right_character_pressed():
	character_right()

func _on_face_toggled(toggled_on):
	if toggled_on:
		character_description.visible = true
	else:
		character_description.visible = false
