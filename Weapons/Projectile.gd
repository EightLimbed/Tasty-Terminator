extends CharacterBody2D


var frames : SpriteFrames
var speed : int = 15000
var damage : int
var pierce : int
var direction : Vector2 = Vector2(1,0)
var collision_shape : Shape2D
var collision_offset : Vector2
var initial_velocity : Vector2
var lifetime_override : float = 0
var random = RandomNumberGenerator.new()
var hit_sound : AudioStream

var circling_radius : int
@onready var collision = $CollisionShape2D
@onready var sprite_frames = $AnimatedSprite2D
@onready var lifetime = $Lifetime

func _ready() -> void:
	collision.position = collision_offset
	if circling_radius == 0:
			rotation = direction.angle()
	if lifetime_override > 0:
		lifetime.wait_time = lifetime_override
	else:
		lifetime.wait_time = min(30000.0/speed, 10)
	sprite_frames.sprite_frames = frames
	collision.shape = collision_shape
	sprite_frames.play()
	lifetime.start()

func _physics_process(delta):
	if not circling_radius == 0:
		if position.x>circling_radius or position.x<-circling_radius:
			direction.x = sign(circling_radius- position.x)
		if position.y>circling_radius or position.y<-circling_radius:
			direction.y = sign(circling_radius -position.y)
		
	velocity = (delta*speed*direction)+initial_velocity
	move_and_slide()

func update_pierce():
	
	if hit_sound:
		play_sound(hit_sound,AudioServer.get_bus_name(2))
	pierce -= 1
	if pierce == 0:
		queue_free()

func play_sound(sound : AudioStream, bus : String):
	var stream_player = AudioStreamPlayer.new()
	stream_player.stream = sound
	stream_player.bus = bus
	get_tree().get_root().get_node("Game").add_child(stream_player)
	stream_player.play()
	stream_player.connect("finished", audio_finished.bind(stream_player))

func audio_finished(stream_player):
	stream_player.queue_free()

func _on_lifetime_timeout() -> void:
	queue_free()
