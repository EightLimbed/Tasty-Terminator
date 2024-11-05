extends TextureProgressBar

var press : bool
@onready var button = $TouchScreenButton

func _process(_delta: float) -> void:
	if press:
		button.global_position.x = max(min(get_global_mouse_position().x, size.x-8+global_position.x),0+global_position.x)
		value = button.position.x/(size.x-8)*100
	else:
		button.position.x = value*(size.x-8)/100

func _on_touch_screen_button_pressed() -> void:
	press = true

func _on_touch_screen_button_released() -> void:
	press = false
