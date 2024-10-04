extends CharacterBody2D

@onready var player = get_tree().get_root().get_node("Game").get_node("Player")
@onready var particles = $CPUParticles2D
var activated : bool = false
var experience : int = 0

func _ready():
	particles.emitting = true

func _physics_process(delta: float):
	if activated:
		var goal = player.global_position
		velocity = (global_position.distance_to(goal)*300+10000)*global_position.direction_to(goal)*delta
		if global_position.distance_to(goal) < 16:
			queue_free()
		move_and_slide()

func _on_timer_timeout():
	queue_free()
