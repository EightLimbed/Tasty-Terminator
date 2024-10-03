extends CharacterBody2D

#movement
var input : Vector2
var speed : int = 30000
var health : int = 20
var experience : int = 0
@onready var joystick = $CanvasLayer/Joystick
#temp
@onready var weapon1 = $WeaponContainer/Weapon

func _physics_process(delta: float) -> void:
	#mobile
	input = joystick.distance
	if experience > 10:
		weapon1.upgrade()
		experience = 0
	#PC
	#input = Vector2(int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left")), int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))).normalized()
	velocity = input*speed*delta*joystick.press
	move_and_slide()

func update_health(damage):
	health -= damage

func _on_experience_pickup_body_entered(body):
	body.activated = true
	experience = body.experience
