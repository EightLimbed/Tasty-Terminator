extends CharacterBody2D

@onready var player = get_tree().get_root().get_node("Game").get_node("Player")
@onready var animation = $AnimatedSprite2D
var profile : Enemy
var health : int
var death = preload("res://Enemies/DeathEffect.tscn")
var experience_container
var random = RandomNumberGenerator.new()
var personality = Vector2.ZERO
var difficulty : float = 1

func _ready():
	experience_container = get_tree().get_root().get_node("Game").get_node("ExperienceContainer")
	#profile = load("res://Enemies/Resources/Default.tres")
	health = profile.health*difficulty
	animation.sprite_frames = profile.frames
	animation.play()

func _physics_process(delta):
	if random.randi_range(0,10) == 0:
		personality = Vector2(random.randi_range(-profile.speed,profile.speed), random.randi_range(-profile.speed,profile.speed))/2
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
		body.update_health(profile.melee_damage*difficulty)

func die():
	var instance = death.instantiate()
	instance.global_position = global_position
	instance.experience = profile.experience_drop*(difficulty-1+difficulty)
	experience_container.add_child.call_deferred(instance)
	queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
