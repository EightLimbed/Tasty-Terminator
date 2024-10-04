extends CharacterBody2D

@onready var player = get_tree().get_root().get_node("Game").get_node("Player")
var activated : bool = false
var experience : int = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float):
	if activated:
		var goal = player.global_position
		velocity = (global_position.distance_to(goal)*300+10000)*global_position.direction_to(goal)*delta
		if global_position.distance_to(goal) < 16:
			queue_free()
		move_and_slide()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
