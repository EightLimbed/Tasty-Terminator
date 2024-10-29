extends CharacterBody2D

@onready var player = get_tree().get_root().get_node("Game").get_node("Player")
var sounds : Array[AudioStream] = [preload("res://Enemies/Sound/Death.mp3"),preload("res://Enemies/Sound/ExperiencePickup.mp3")]
var activated : bool = false
var experience : int = 0

func _ready():
	play_sound(sounds[0],AudioServer.get_bus_name(2))

func _physics_process(delta: float):
	if activated:
		var goal = player.global_position
		velocity = (global_position.distance_to(goal)*300+40000)*global_position.direction_to(goal)*delta
		if global_position.distance_to(goal) < 16:
			play_sound(sounds[1],AudioServer.get_bus_name(2))
			queue_free()
			player.update_experience(experience)
		move_and_slide()

func play_sound(sound : AudioStream, bus : String):
	var stream_player = AudioStreamPlayer.new()
	stream_player.stream = sound
	stream_player.bus = bus
	player.add_child(stream_player)
	stream_player.play()
	stream_player.connect("finished", audio_finished.bind(stream_player))

func audio_finished(stream_player):
	stream_player.queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
