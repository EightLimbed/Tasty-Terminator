extends CharacterBody2D

var frames : SpriteFrames
var speed : int
var damage : int
var pierce : int
var lifetime : float

@onready var collision = $CollisionShape2D
@onready var spriteframes = $AnimatedSprite2D
@onready var timer = $Lifetime

func _ready():
	timer.wait_time = lifetime
	

func _physics_process(delta):
	pass
