extends Control

@onready var bus_layout = preload("res://default_bus_layout.tres")
@onready var music_button = $VBoxContainer/Music
@onready var music_slider = $VBoxContainer/Music/MusicSlider

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioServer.set_bus_volume_db(1,linear_to_db(50.0/12.0))

func _on_exit_pressed() -> void:
	visible = false

func _on_music_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(1,linear_to_db(value/12.0))
	if value <= 0:
		music_button.button_pressed = true
	else:
		music_button.button_pressed = false

func _on_music_toggled(toggled_on: bool) -> void:
	if toggled_on:
		music_slider.value = 0
	else:
		music_slider.value = 50
