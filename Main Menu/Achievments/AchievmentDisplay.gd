extends Control

@onready var save_file = preload("res://Main Menu/Achievments/LocalAchievments.tres")
@onready var achievment_container = $VBoxContainer
@onready var unlocked_texture : Texture2D = load("res://Main Menu/Art/AchievmentUnlocked.png")
@onready var locked_texture : Texture2D = load("res://Main Menu/Art/AchievmentLocked.png")

func _ready() -> void:
	var achievments = save_file.achievments.keys()
	for key in achievments:
		var display = NinePatchRect.new()
		display.patch_margin_left = 15
		display.patch_margin_top = 15
		display.patch_margin_right = 5
		display.patch_margin_bottom = 5
		if save_file.achievments[key]:
			display.texture = unlocked_texture
		else:
			display.texture = locked_texture
		var label = Label.new()
		label.text = key
		label.label_settings = load("res://HUD/Name.tres")
		label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		label.size.x = 232
		label.position = Vector2(18,0)
		display.add_child(label)
		achievment_container.add_child(display)
		display.custom_minimum_size.y = label.size.y+3
