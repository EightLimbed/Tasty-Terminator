extends Area2D

@onready var player = get_tree().get_root().get_node("Game").get_node("Player")
var activated : bool = false
var experience : int = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if activated:
		var goal = player.global_position
		global_position += (global_position.distance_to(goal)/10+15000)*global_position.direction_to(goal)*delta
		if global_position.distance_to(goal) < 16:
			queue_free()
