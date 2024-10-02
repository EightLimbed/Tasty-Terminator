extends CharacterBody2D

#movement
var input : Vector2
var speed : int = 30000
var health : int = 20
@onready var joystick = $CanvasLayer/Joystick
#temp
@onready var weapon1 = $WeaponContainer/Weapon

func _physics_process(delta: float) -> void:
	#mobile
	input = joystick.distance
	if Input.is_action_just_pressed("ui_accept"):
		weapon1.upgrade()
	#PC
	#input = Vector2(int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left")), int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))).normalized()
	velocity = input*speed*delta*joystick.press
	move_and_slide()

func update_health(damage):
	health -= damage
