extends CharacterBody2D

func _ready():
	pass

func _physics_process(delta):
	velocity = 15000*delta

	move_and_slide()
