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

@onready var collision = $CollisionShape2D
@onready var sprite_frames = $AnimatedSprite2D
@onready var lifetime = $Lifetime

func _ready() -> void:
	collision.position = collision_offset
	rotation = direction.angle()
	if lifetime_override > 0:
		lifetime.wait_time = lifetime_override
	else:
		lifetime.wait_time = min(30000.0/speed, 10)
	sprite_frames.sprite_frames = frames
	collision.shape = collision_shape
	sprite_frames.play()
	sprite_frames.frame = random.randi_range(0,2)
	lifetime.start()

func _physics_process(delta):
	velocity = (delta*speed*direction)+initial_velocity
	move_and_slide()

func update_pierce():
	pierce -= 1
	if pierce == 0:
		queue_free()

func _on_lifetime_timeout() -> void:
	queue_free()
