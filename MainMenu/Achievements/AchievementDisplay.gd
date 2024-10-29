extends Control

@onready var achievement_container = $ScrollContainer/VBoxContainer
@onready var unlocked_texture : Texture2D = load("res://MainMenu/Art/AchievementUnlocked.png")
@onready var locked_texture : Texture2D = load("res://MainMenu/Art/AchievementLocked.png")
@onready var click_sound = $AudioStreamPlayer

func update(save_file) -> void:
	for child in achievement_container.get_children():
		child.queue_free()
	var achievements = save_file.achievements.keys()
	for key in achievements:
		var display = NinePatchRect.new()
		display.patch_margin_left = 15
		display.patch_margin_top = 15
		display.patch_margin_right = 5
		display.patch_margin_bottom = 5
		if save_file.achievements[key]:
			display.texture = unlocked_texture
		else:
			display.texture = locked_texture
		var label = Label.new()
		label.text = key
		label.label_settings = load("res://HUD/Name.tres")
		label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		label.size.x = 256
		label.position = Vector2(18,0)
		display.add_child(label)
		achievement_container.add_child(display)
		display.custom_minimum_size.y = label.size.y+6
	#for i in 100:
		#var display = NinePatchRect.new()
		#display.patch_margin_left = 15
		#display.patch_margin_top = 15
		#display.patch_margin_right = 5
		#display.patch_margin_bottom = 5
		#display.texture = locked_texture
		#achievement_container.add_child(display)

func _on_exit_pressed() -> void:
	click_sound.play()
	visible = false
