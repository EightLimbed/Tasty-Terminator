extends CharacterBody2D

#movement
var input : Vector2
var speed : int = 50000
@onready var joystick = $CanvasLayer/Joystick

func _physics_process(delta: float) -> void:
	#mobile
	input = joystick.distance
	#PC
	#input = Vector2(int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left")), int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))).normalized()
	velocity = input*speed*delta
	move_and_slide()
