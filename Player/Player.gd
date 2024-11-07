extends CharacterBody2D

#character profile
var profile : Character

#movement
var input : Vector2
var control_type : bool
var health : float
var experience : float = 0
@onready var hud = $HUD
@onready var animation = $AnimatedSprite2D
@onready var face = $Face
@onready var starting_weapon = $WeaponContainer/StartingWeapon
@onready var death_screen = $HUD/DeathScreen
@onready var pickup_radius = $Hitbox/CollisionShape2D
@onready var level_up_sound = $AudioStreamPlayer
var level : int = 0

func start(character_profile):
	profile = character_profile.duplicate()
	health = float(profile.max_health.x)
	pickup_radius.shape.radius = profile.aroma
	if profile.starting_weapon:
		starting_weapon.profile = profile.starting_weapon.duplicate()
	hud.possible_weapons.erase(profile.starting_weapon)
	starting_weapon.start()
	animation.sprite_frames = profile.sprite_frames
	hud.update_health(0,health,profile.max_health.x)
	for i in profile.head_start:
		hud.level_up(0)
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
	elif health < profile.max_health.x/2.0:
		face.frame = 1
	else:
		face.frame = 0
	if control_type:
		hud.joystick.visible = true
		input = hud.joystick.distance
		velocity = input*profile.speed.x*delta*hud.joystick.press
	else:
		hud.joystick.visible = false
		var take = Vector2(int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left")), int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))).normalized()
		if not take == Vector2.ZERO and health >= 0:
			input = take
		if health >= 0:
			velocity = take*profile.speed.x*delta
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
		experience -= round(level**1.5 + 2.0)
		level_up_sound.play()
		hud.level_up(0)
	hud.update_experience(0, experience*10, (level**1.5 + 2)*10)

func _on_hitbox_body_entered(body):
	body.activated = true
