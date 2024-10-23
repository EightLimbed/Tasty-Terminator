extends Control

@onready var game = preload("res://Game/Game.tscn").instantiate()
@onready var random = RandomNumberGenerator.new()
@onready var background = $NinePatchRect
@onready var vbox = $VBoxContainer
@onready var character_select = $VBoxContainer/CharacterSelect
@onready var character_display = $VBoxContainer/CharacterSelect/Display
@onready var character_description = $VBoxContainer/CharacterSelect/Description
@onready var character_description_label = $VBoxContainer/CharacterSelect/Description/Label
@onready var level_description = $VBoxContainer/LevelSelect
@onready var level_description_label = $VBoxContainer/LevelSelect/Label
@onready var achievement_display = $AchievmentDisplay
@onready var save_file = preload("res://MainMenu/Achievements/LocalAchievements.tres")
@onready var world = $World
var world_seed : int
var characters : Array[Character] = [preload("res://Player/Characters/Resources/Cookie.tres"), preload("res://Player/Characters/Resources/Donut.tres")]
var c_index : int = 0
var maps : Array[World] = [preload("res://World/Resources/Rural.tres"), preload("res://World/Resources/Forest.tres")]
var m_index : int = 0

func _ready() -> void:
	character_description_label.text = "Cookie:\nThe original tasty terminator, fires chocolate chips. gains health and speed every level."
	world_seed = random.randi()
	achievement_display.visible = false
	maps[m_index].seeded = world_seed
	world.update_profile(maps[m_index])
	world.generate_roads(Vector2.ZERO, Vector2i(52,52))
	world.generate_roads(Vector2.ZERO, Vector2i(52,52))
	save_file.verify_save()
	load_achievments()
	character_display.play()

#things that cannot be called by updates
func _process(_delta: float) -> void:
	background.size = vbox.size+Vector2(112,12)
	background.position = vbox.position-Vector2(56,6)
	character_description.custom_minimum_size.y = character_description_label.size.y+6
	level_description.custom_minimum_size.y = level_description_label.size.y+6
	character_select.custom_minimum_size.y = 80 + character_description_label.size.y+6

func load_achievments():
	if ResourceLoader.exists("user://save/AchievementLog.tres"):
		save_file = ResourceLoader.load("user://save/AchievementLog.tres")
	if save_file.achievements["Reach Level 100 (Unlocks Gummy Bear)"]:
		characters.append(load("res://Player/Characters/Resources/GummyBear.tres"))

func character_left():
	if characters.size()-1 > c_index:
		c_index += 1
	else:
		c_index = 0
	character_display.sprite_frames = characters[c_index].sprite_frames
	character_description_label.text = characters[c_index].name + ":\n" + characters[c_index].description
	character_display.play()

func character_right():
	if 0 < c_index:
		c_index -= 1
	else:
		c_index = characters.size()-1
	character_display.sprite_frames = characters[c_index].sprite_frames
	character_description_label.text = characters[c_index].name + ":\n" + characters[c_index].description
	character_display.play()

func world_left():
	if maps.size()-1 > m_index:
		m_index += 1
	else:
		m_index = 0
	maps[m_index].seeded = world_seed
	world.roads_cache = []
	level_description_label.text = maps[m_index].name + ":\n" + maps[m_index].description
	world.update_profile(maps[m_index])
	world.generate_roads(Vector2.ZERO, Vector2i(32,52))
	world.generate_roads(Vector2.ZERO, Vector2i(32,52))

func world_right():
	if 0 < m_index:
		m_index -= 1
	else:
		m_index = maps.size()-1
	maps[m_index].seeded = world_seed
	world.roads_cache = []
	level_description_label.text = maps[m_index].name + ":\n" + maps[m_index].description
	world.update_profile(maps[m_index])
	world.generate_roads(Vector2.ZERO, Vector2i(32,52))
	world.generate_roads(Vector2.ZERO, Vector2i(32,52))

func _on_temp_start_pressed() -> void:
	game.character_profile = characters[c_index]
	game.world_profile = maps[m_index]
	get_tree().root.add_child(game)
	queue_free()

func _on_temp_left_character_pressed():
	character_left()

func _on_temp_right_character_pressed():
	character_right()

func _on_temp_achievments_pressed() -> void:
	achievement_display.update(save_file)
	if achievement_display.visible ==true:
		achievement_display.visible = false
	else:
		achievement_display.visible = true

func _on_left_button_pressed() -> void:
	character_left()

func _on_right_button_pressed() -> void:
	character_right()

func _on_right_button_m_pressed() -> void:
	world_right()

func _on_left_button_m_pressed() -> void:
	world_left()
