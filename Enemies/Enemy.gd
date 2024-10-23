extends CharacterBody2D

@onready var player = get_tree().get_root().get_node("Game").get_node("Player")
@onready var animation = $AnimatedSprite2D
@onready var hitbox = $Area2D/CollisionShape2D
var profile : Enemy
var health : int
var death = preload("res://Enemies/Experience.tscn")
@onready var experience_container = get_tree().get_root().get_node("Game").get_node("ExperienceContainer")
var random = RandomNumberGenerator.new()
var personality = Vector2.ZERO
var difficulty : float = 1
var attacking : bool = false

func _ready():
	#profile = load("res://Enemies/Resources/Default.tres")
	health = round(profile.health*difficulty**1.5)
	animation.sprite_frames = profile.frames
	hitbox.shape = profile.hitbox
	if difficulty > 2.0:
		scale *= min(difficulty/2,2)
	animation.play()

func _physics_process(delta):
	if random.randi_range(0,10) == 0:
		personality = Vector2(random.randi_range(-profile.speed,profile.speed), random.randi_range(-profile.speed,profile.speed))/2
	if attacking:
		player.update_health(profile.melee_damage*delta*difficulty**1.5)
	velocity = (profile.speed*global_position.direction_to(player.global_position)+personality)*delta*difficulty
	move_and_slide()

func _on_area_2d_body_entered(body):
	#print(body.collision_layer)
	if body.collision_layer == 8:
		body.update_pierce()
		health -= body.damage
		if health <= 0:
			die()
	if body.collision_layer == 2:
		attacking = true

func _on_area_2d_body_exited(body):
	if body.collision_layer == 2:
		attacking = false

func die():
	var instance = death.instantiate()
	instance.global_position = global_position
	instance.experience = profile.experience_drop*(difficulty+1)
	experience_container.add_child.call_deferred(instance)
	queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
