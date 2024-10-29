extends Control

@onready var bus_layout = preload("res://default_bus_layout.tres")
@onready var music_button = $VBoxContainer/Sound/Music
@onready var music_slider = $VBoxContainer/Sound/Music/MusicSlider
@onready var sound_effects_button = $VBoxContainer/Sound/SoundEffects
@onready var sound_effects_slider = $VBoxContainer/Sound/SoundEffects/SoundEffectsSlider
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
	click_sound.play()
	menu.visible = true

func _on_exit_pressed() -> void:
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
		music_button.button_pressed = true
	else:
		music_button.button_pressed = false

func _on_music_toggled(toggled_on: bool) -> void:
	click_sound.play()
	if toggled_on:
		music_cache = music_slider.value
		music_slider.value = 0
	else:
		if music_cache > 1:
			music_slider.value = music_cache
		else:
			music_slider.value = 50

func _on_sound_effects_slider_value_changed(value):
	click_sound.play()
	AudioServer.set_bus_volume_db(2,linear_to_db(value/100.0))
	save_file.sound_effect_volume = value
	if value <= 0:
		sound_effects_button.button_pressed = true
	else:
		sound_effects_button.button_pressed = false

func _on_sound_effects_toggled(toggled_on):
	click_sound.play()
	if toggled_on:
		sound_effects_cache = sound_effects_slider.value
		sound_effects_slider.value = 0
	else:
		if music_cache > 1:
			sound_effects_slider.value = sound_effects_cache
		else:
			sound_effects_slider.value = 50

func _on_right_button_m_pressed() -> void:
	click_sound.play()
	if save_file.control_type:
		save_file.control_type = false
		control_label.text = "Keyboard Controls"
	else:
		save_file.control_type = true
		control_label.text = "Mobile Controls"

func _on_left_button_m_pressed() -> void:
	click_sound.play()
	if save_file.control_type:
		save_file.control_type = false
		control_label.text = "Keyboard Controls"
	else:
		save_file.control_type = true
		control_label.text = "Mobile Controls"

func _on_menu_pressed() -> void:
	click_sound.play()
	var game = get_tree().get_root().get_node("Game")
	get_tree().change_scene_to_file("res://MainMenu/MainMenu.tscn")
	game.queue_free()
