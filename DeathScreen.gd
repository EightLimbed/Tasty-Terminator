extends Control

@onready var game = get_tree().get_root().get_node("Game")
@onready var wave_timer = game.get_node("WaveTimer")
@onready var enemy_container = game.get_node("EnemyContainer")
@onready var player = game.get_node("Player")
@onready var joystick = player.get_node("Joystick")

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func death():
	wave_timer.stop()
	visible = true
	for child in enemy_container.get_children():
		child.queue_free()
	joystick.visible = false


func _on_temp_menu_pressed():
	get_tree().change_scene_to_file("res://MainMenu/MainMenu.tscn")
	game.queue_free()

func _on_temp_revive_pressed():
	wave_timer.start()
	visible = false
	player.update_health(-player.profile.max_health.x/2)
	joystick.visible = true
