extends CharacterBody2D

@onready var player = get_tree().get_root().get_node("Game").get_node("Player")
@onready var animation = $AnimatedSprite2D
var profile : Enemy
var health : int

func _ready():
	profile = preload("res://Enemies/Resources/Default.tres")
	health = profile.health
	animation.play()

func _physics_process(delta):
	velocity = profile.speed*global_position.direction_to(player.global_position)*delta
	move_and_slide()

func _on_area_2d_body_entered(body):
	#print(body.collision_layer)
	if body.collision_layer == 8:
		body.update_pierce()
		health -= body.damage
		if health <= 0:
			queue_free()
	if body.collision_layer == 2:
		body.update_health(profile.melee_damage)

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
