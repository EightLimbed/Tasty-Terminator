extends CharacterBody2D

#movement
var input : Vector2
var speed : int = 30000
var health : int = 100
var experience : int = 0
@onready var joystick = $Joystick
@onready var hud = $HUD
#temp
@onready var weapon1 = $WeaponContainer/Weapon

func _ready():
	hud.update_health(0,health,100)

func _physics_process(delta: float) -> void:
	#mobile
	input = joystick.distance
	if experience > weapon1.level**2:
		weapon1.upgrade()
		experience = 0
		hud.update_experience(0,experience,weapon1.level**2)
	#PC
	#input = Vector2(int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left")), int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))).normalized()
	velocity = input*speed*delta*joystick.press
	move_and_slide()

func update_health(damage):
	health -= damage
	hud.update_health(0,health,100)

func _on_hitbox_body_entered(body):
	body.activated = true
	experience += body.experience
	hud.update_experience(0,experience,weapon1.level**2)
