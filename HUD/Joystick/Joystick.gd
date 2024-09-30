extends TouchScreenButton

var joystick_pressed : bool = false
@onready var knob = $Knob
var distance : Vector2 = Vector2.ZERO

func _process(delta: float) -> void:
	if not joystick_pressed:
		global_position = get_global_mouse_position()-Vector2(64,64)
		knob.position = Vector2(64,64)
		distance = Vector2.ZERO
		modulate.a = 0
	else:
		distance = (get_global_mouse_position()-global_position-Vector2(64,64)).limit_length(64)/64
		knob.position = distance*64+Vector2(64,64)
		modulate.a = 255

func _on_pressed() -> void:
	joystick_pressed = true

func _on_released() -> void:
	joystick_pressed = false
