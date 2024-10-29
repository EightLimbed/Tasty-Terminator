extends Control

@onready var game = get_tree().get_root().get_node("Game")
@onready var wave_timer = game.get_node("WaveTimer")
@onready var enemy_container = game.get_node("EnemyContainer")
@onready var game_music = game.get_node("AudioStreamPlayer")
@onready var player = game.get_node("Player")
@onready var settings = player.get_node("HUD").get_node("Settings")
@onready var joystick = player.get_node("Joystick")
@onready var revive = $VBoxContainer/Revive
@onready var music = $AudioStreamPlayer
@onready var score = $Score
@onready var display = $Display
@onready var click_sound = $AudioStreamPlayer2

func _ready():
	visible = false

func death():
	settings.visible = false
	display.sprite_frames = player.profile.sprite_frames
	score.text = "You reached level " + str(player.level) + " at wave " + str(game.wave)
	if visible == false:
		music.play()
		game_music.stop()
		wave_timer.stop()
	visible = true
	for child in enemy_container.get_children():
		child.queue_free()
		if player.profile.revivals > 0:
			revive.visible = true
		else:
			revive.visible = false
		joystick.visible = false

func _on_menu_pressed():
	click_sound.play()
	get_tree().change_scene_to_file("res://MainMenu/MainMenu.tscn")
	game.queue_free()

func _on_revive_pressed():
	click_sound.play()
	music.stop()
	game.update_music()
	player.profile.revivals -= 1
	wave_timer.start()
	visible = false
	player.update_health(-player.profile.max_health.x/2)
	joystick.visible = true
