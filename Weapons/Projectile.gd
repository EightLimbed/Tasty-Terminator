extends CharacterBody2D

var frames : Texture2D
var speed : int = 15000
var damage : int
var pierce : int
var direction : Vector2 = Vector2(1,0)
var collision_shape : Shape2D
var initial_velocity : Vector2

@onready var collision = $CollisionShape2D
@onready var texture = $Sprite2D
@onready var lifetime = $Lifetime
@onready var label = $Label

func _ready() -> void:
	lifetime.wait_time = min(30000.0/speed, 10)
	texture.texture = frames
	collision.shape = collision_shape
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
