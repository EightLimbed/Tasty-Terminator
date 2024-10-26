extends Control

@onready var bus_layout = preload("res://default_bus_layout.tres")
@onready var music_button = $VBoxContainer/Music
@onready var music_slider = $VBoxContainer/Music/MusicSlider
@onready var save_file = preload("res://MainMenu/Achievements/LocalAchievements.tres")
@onready var control_label = $VBoxContainer/ControlType/Label
@onready var menu = $VBoxContainer/Menu

func _ready() -> void:
	menu.visible = false
	if ResourceLoader.exists("user://save/AchievementLog.tres"):
		save_file = ResourceLoader.load("user://save/AchievementLog.tres")
	AudioServer.set_bus_volume_db(1,linear_to_db(save_file.music_volume/12.0))
	music_slider.value = save_file.music_volume
	if save_file.control_type:
		control_label.text = "Mobile Controls"
	else:
		control_label.text = "Keyboard Controls"

func menu_button():
	menu.visible = true

func _on_exit_pressed() -> void:
	if menu.visible:
		var player = get_tree().get_root().get_node("Game").get_node("Player")
		player.control_type = save_file.control_type
	visible = false
	ResourceSaver.save(save_file, "user://save/AchievementLog.tres")

func _on_music_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(1,linear_to_db(value/12.0))
	save_file.music_volume = value
	if value <= 0:
		music_button.button_pressed = true
	else:
		music_button.button_pressed = false

func _on_music_toggled(toggled_on: bool) -> void:
	if toggled_on:
		music_slider.value = 0
	else:
		music_slider.value = 50

func _on_right_button_m_pressed() -> void:
	if save_file.control_type:
		save_file.control_type = false
		control_label.text = "Keyboard Controls"
	else:
		save_file.control_type = true
		control_label.text = "Mobile Controls"

func _on_left_button_m_pressed() -> void:
	if save_file.control_type:
		save_file.control_type = false
		control_label.text = "Keyboard Controls"
	else:
		save_file.control_type = true
		control_label.text = "Mobile Controls"

func _on_menu_pressed() -> void:
	var game = get_tree().get_root().get_node("Game")
	get_tree().change_scene_to_file("res://MainMenu/MainMenu.tscn")
	game.queue_free()
