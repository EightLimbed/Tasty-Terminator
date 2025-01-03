extends Control

@onready var game = preload("res://Game/Game.tscn").instantiate()
@onready var click_sound = $AudioStreamPlayer2
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
@onready var settings = $Settings
@onready var save_file = preload("res://MainMenu/Achievements/LocalAchievements.tres")
@onready var world = $World
@onready var cright = $VBoxContainer/CharacterSelect/RightButton
@onready var cleft = $VBoxContainer/CharacterSelect/LeftButton
@onready var mright = $VBoxContainer/LevelSelect/RightButtonM
@onready var mleft = $VBoxContainer/LevelSelect/LeftButtonM
@onready var loading_screen = $Loading
var world_seed : int
var characters : Array[Character] = [preload("res://Player/Characters/Resources/Cookie.tres")]
var c_index : int = 0
var maps : Array[World] = [preload("res://World/Resources/Rural.tres")]
var m_index : int = 0

#if an achievement unlocks something, add check for achievment, and add resource to respective list
func load_achievments():
	if save_file.achievements["Reach level 100 (Unlocks Gummy Bear)"]:
		characters.append(preload("res://Player/Characters/Resources/GummyBear.tres"))
	if save_file.achievements["Reach level 100 with starting weapon (Unlocks Donut)"]:
		characters.append(preload("res://Player/Characters/Resources/Donut.tres"))
	if save_file.achievements["Come back from the dead twice in a single game (Unlocks Candy Corn)"]:
		characters.append(preload("res://Player/Characters/Resources/CandyCorn.tres"))
	if save_file.achievements["Reach wave 100 on Rural map (Unlocks Forest map)"]:
		maps.append(preload("res://World/Resources/Forest.tres"))
	if save_file.achievements["Reach wave 100 on Forest map (Unlocks Desert map)"]:
		maps.append(preload("res://World/Resources/Desert.tres"))
	if save_file.achievements["Reach wave 100 on Desert Map (Unlocks Snow map)"]:
		maps.append(preload("res://World/Resources/Snow.tres"))
	if save_file.achievements["Reach wave 200 with Cookie on Snow map (Unlocks Candy Cane)"]:
		characters.append(preload("res://Player/Characters/Resources/CandyCane.tres"))

func _ready() -> void:
	loading_screen.visible = false
	character_description_label.text = "Cookie:\nThe original tasty terminator, fires chocolate chips. gains health and speed every level."
	world_seed = random.randi()
	achievement_display.visible = false
	maps[m_index].seeded = world_seed
	world.update_profile(maps[m_index])
	world.generate_roads(Vector2.ZERO, Vector2i(52,52))
	world.generate_roads(Vector2.ZERO, Vector2i(52,52))
	save_file.verify_save()
	if ResourceLoader.exists("user://save/AchievementLog.tres"):
		save_file = ResourceLoader.load("user://save/AchievementLog.tres")
	load_achievments()
	if characters.size() > 1:
		cright.visible = true
		cleft.visible = true
	else:
		cright.visible = false
		cleft.visible = false
	if maps.size() > 1:
		mright.visible = true
		mleft.visible = true
	else:
		mright.visible = false
		mleft.visible = false
	character_display.play()

#things that cannot be called by updates
func _process(_delta: float) -> void:
	background.size = vbox.size+Vector2(112,12)
	background.position = vbox.position-Vector2(56,6)
	character_description.custom_minimum_size.y = character_description_label.size.y+6
	level_description.custom_minimum_size.y = level_description_label.size.y+6
	character_select.custom_minimum_size.y = 80 + character_description_label.size.y+6

func character_right():
	click_sound.play()
	if characters.size()-1 > c_index:
		c_index += 1
	else:
		c_index = 0
	character_display.sprite_frames = characters[c_index].sprite_frames
	character_description_label.text = characters[c_index].name + ":\n" + characters[c_index].description
	character_display.play()

func character_left():
	click_sound.play()
	if 0 < c_index:
		c_index -= 1
	else:
		c_index = characters.size()-1
	character_display.sprite_frames = characters[c_index].sprite_frames
	character_description_label.text = characters[c_index].name + ":\n" + characters[c_index].description
	character_display.play()

func world_right():
	click_sound.play()
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

func world_left():
	click_sound.play()
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

func _on_achievments_released() -> void:
	click_sound.play()
	achievement_display.update(save_file)
	achievement_display.visible = true

func _on_settings_released() -> void:
	click_sound.play()
	settings.visible = true

func _on_start_released() -> void:
	click_sound.play()
	game.character_profile = characters[c_index]
	game.world_profile = maps[m_index]
	game.save_file = save_file
	loading_screen.visible = true
	get_tree().root.add_child(game)
	queue_free()

func _on_left_button_released() -> void:
	character_right()

func _on_right_button_released() -> void:
	character_left()

func _on_right_button_m_released() -> void:
	world_left()

func _on_left_button_m_released() -> void:
	world_right()
