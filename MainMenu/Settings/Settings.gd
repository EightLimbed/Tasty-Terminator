extends Control

@onready var bus_layout = preload("res://default_bus_layout.tres")
@onready var music_slider = $VBoxContainer/Music/Slider
@onready var music_display = $VBoxContainer/Music/Display
@onready var sound_effects_slider = $VBoxContainer/SoundEffects/Slider
@onready var sound_effects_display = $VBoxContainer/SoundEffects/Display
@onready var save_file = preload("res://MainMenu/Achievements/LocalAchievements.tres")
@onready var control_label = $VBoxContainer/ControlType/Label
@onready var menu = $VBoxContainer/Menu
@onready var click_sound = $AudioStreamPlayer
var music_cache : int
var sound_effects_cache : int

func _ready() -> void:
	menu.visible = false
	if ResourceLoader.exists("user://save/AchievementLog.tres"):
		save_file = ResourceLoader.load("user://save/AchievementLog.tres")
	music_slider.value = save_file.music_volume
	sound_effects_slider.value = save_file.sound_effect_volume
	if save_file.control_type:
		control_label.text = "Mobile Controls"
	else:
		control_label.text = "Keyboard Controls"

func menu_button():
	menu.visible = true

func _on_exit_released() -> void:
	click_sound.play()
	if menu.visible:
		var player = get_tree().get_root().get_node("Game").get_node("Player")
		player.control_type = save_file.control_type
	visible = false
	ResourceSaver.save(save_file, "user://save/AchievementLog.tres")

func _on_music_slider_value_changed(value: float) -> void:
	click_sound.play()
	AudioServer.set_bus_volume_db(1,linear_to_db(value/100.0))
	save_file.music_volume = value
	if value <= 0:
		music_display.frame = 1
	else:
		music_display.frame = 0

func _on_sound_effects_slider_value_changed(value: float) -> void:
	click_sound.play()
	AudioServer.set_bus_volume_db(2,linear_to_db(value/100.0))
	save_file.sound_effect_volume = value
	if value <= 0:
		sound_effects_display.frame = 1
	else:
		sound_effects_display.frame = 0

func _on_right_button_m_released() -> void:
	click_sound.play()
	if save_file.control_type:
		save_file.control_type = false
		control_label.text = "Keyboard Controls"
	else:
		save_file.control_type = true
		control_label.text = "Mobile Controls"

func _on_left_button_m_released() -> void:
	click_sound.play()
	if save_file.control_type:
		save_file.control_type = false
		control_label.text = "Keyboard Controls"
	else:
		save_file.control_type = true
		control_label.text = "Mobile Controls"

func _on_menu_released() -> void:
	click_sound.play()
	var game = get_tree().get_root().get_node("Game")
	get_tree().change_scene_to_file("res://MainMenu/MainMenu.tscn")
	game.queue_free()
