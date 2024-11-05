extends TouchScreenButton

var joystick_pressed : bool = false
@onready var knob = $Knob
var distance : Vector2 = Vector2(0,1)
var press : int = 0

func _process(_delta):
	if joystick_pressed:
		distance = (get_global_mouse_position()-global_position-Vector2(64,64)).limit_length(64)/64
		knob.position = distance*64+Vector2(64,64)
		press = 1
		modulate.a = 155
	else:
		knob.position = Vector2(64,64)
		press = 0
		modulate.a = 155


func _on_released():
	joystick_pressed = false
