extends CharacterBody2D

#character profile
var profile = preload("res://Player/Characters/Resources/GummyBear.tres")

#movement
var input : Vector2
var health : float = float(profile.max_health.x)
var experience : int = 0
@onready var joystick = $Joystick
@onready var hud = $HUD
@onready var animation = $AnimatedSprite2D
@onready var face = $Face
@onready var starting_weapon = $WeaponContainer/StartingWeapon
@onready var death_screen = $HUD/DeathScreen
@onready var pickup_radius = $Hitbox/CollisionShape2D
var level : int = 0
#temp

func start(character_profile):
	profile = character_profile
	pickup_radius.shape.radius = profile.aroma
	starting_weapon.profile = profile.starting_weapon
	hud.possible_weapons.erase(profile.starting_weapon)
	starting_weapon.start()
	animation.sprite_frames = profile.sprite_frames
	hud.update_health(0,health,profile.max_health.x)
	for i in profile.head_start:
		hud.level_up()
	animation.play()

func _physics_process(delta: float) -> void:
	if input.x > 0:
		animation.flip_h = true
		face.flip_h = true
	else:
		animation.flip_h = false
		face.flip_h = false
	if health < profile.max_health.x and health > 0:
		update_health(-profile.health_regen.x * delta)
	if  health <= 0:
		face.frame = 2
		death_screen.death()
	elif health < profile.max_health.x/2:
		face.frame = 1
	else:
		face.frame = 0
	#mobile
	input = joystick.distance
	#PC
	#input = Vector2(int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left")), int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))).normalized()
	velocity = input*profile.speed.x*delta*joystick.press
	move_and_slide()

func update_health(damage : float):
	health -= damage
	hud.update_health(0,health,profile.max_health.x)

func update_experience(increase):
	experience += increase*profile.flavor.x
	while experience >= level**1.5 + 2:
		profile.max_health.x += profile.max_health.y
		profile.health_regen.x += profile.health_regen.y
		profile.speed.x += profile.speed.y
		profile.hunger.x += profile.hunger.y
		profile.flavor.x += profile.flavor.y
		level += 1
		experience -= level**1.5 + 2
		hud.level_up()
	hud.update_experience(0, experience, level**2 + 2)

func _on_hitbox_body_entered(body):
	body.activated = true
