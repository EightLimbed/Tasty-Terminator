extends CharacterBody2D

var input : Vector2
var speed : int = 50000

func _physics_process(delta: float) -> void:
	input.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	input.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	velocity = input.normalized()*speed*delta
	move_and_slide()
