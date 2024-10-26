extends CanvasLayer

@onready var health_bar = $Healthbar
@onready var experience_bar = $Experiencebar
@onready var level_display = $LevelDisplay
#add weapon children
@onready var weapon_scene = preload("res://Weapons/Weapon.tscn")
@onready var game = get_tree().get_root().get_node("Game")
@onready var player = game.get_node("Player")
@onready var weapon_container = player.get_node("WeaponContainer")
@onready var level_up_window = $Levelup
@onready var tooltip_label = $Levelup/NinePatchRect/LevelTooltip/Label
@onready var tooltip_box = $Levelup/NinePatchRect/LevelTooltip
@onready var inventory = $Inventory/HBoxContainer
@onready var autolevel_display = $Autolevel
@onready var save_file = preload("res://MainMenu/Achievements/LocalAchievements.tres")
var random = RandomNumberGenerator.new()
var possible_weapons : Array[Weapon] = [preload("res://Weapons/Resources/Chipper.tres"), preload("res://Weapons/Resources/BearTrap.tres")]
var max_weapons : int = 5
var levels_cached : int = 0
@onready var levels_display = $Levelup/NinePatchRect/Title
@onready var option1_button = $Levelup/NinePatchRect/Option1
@onready var option2_button = $Levelup/NinePatchRect/Option2
@onready var option3_button = $Levelup/NinePatchRect/Option3
var option1
var option2
var option3

#if an achievement unlocks something, add check for achievment, and add resource to respective list
func load_achievments():
	if save_file.achievements["Reach level 250 with Donut (Unlocks GLazer)"]:
		possible_weapons.append(load("res://Weapons/Resources/GLazer.tres"))
	if save_file.achievements["Reach level 250 with Cookie (Unlocks Chipper)"]:
		pass
		#possible_weapons.append(load("res://Weapons/Resources/Chipper.tres"))
	if save_file.achievements["Reach level 250 with Gummy Bear (Unlocks Bear Trap)"]:
		pass
		#possible_weapons.append(load("res://Weapons/Resources/BearTrap.tres"))

func _ready():
	save_file.verify_save()
	if ResourceLoader.exists("user://save/AchievementLog.tres"):
		save_file = ResourceLoader.load("user://save/AchievementLog.tres")
	load_achievments()
	autolevel_display.visible = false
	level_up_window.visible = false
	tooltip_box.visible = false

func _process(_delta: float) -> void:
	#stuff that cant go off of existing updates
	level_display.text = "Level " + str(player.level+1) + ", Wave " + str(game.wave)
	tooltip_box.size.y = tooltip_label.size.y+3
	update_inventory()

func level_up(pickup):
	if pickup is Weapon:
		option1 = pickup
		option2 = pickup
		option3 = pickup
		option1_button.update_texture(option1)
		option2_button.update_texture(option2)
		option3_button.update_texture(option3)
		if level_up_window.visible:
				levels_cached += 1
		level_up_window.visible = true
		if levels_cached > 0:
			levels_display.text = "Item Found, " + str(levels_cached+1) + " Level Ups"
		else:
			levels_display.text = "Item Found"
	else:
		if player.level < 100 or levels_cached > 0:
			autolevel_display.visible = false
			level_display.text = "Level " + str(player.level+1)
			if level_up_window.visible:
				levels_cached += 1
			else:
				level_up_window.visible = true
				if player.level - levels_cached <= 1 and possible_weapons.size() >= 1:
					option1 = possible_weapons[random.randi_range(0,possible_weapons.size()-1)]
					option2 = possible_weapons[random.randi_range(0,possible_weapons.size()-1)]
					option3 = possible_weapons[random.randi_range(0,possible_weapons.size()-1)]
				else:
					if weapon_container.get_child_count() < max_weapons and random.randi_range(0,2) == 0 and possible_weapons.size()>0:
						option1 = possible_weapons[random.randi_range(0,possible_weapons.size()-1)]
					else:
						option1 = random.randi_range(0, weapon_container.get_child_count()-1)
					option2 = random.randi_range(0, weapon_container.get_child_count()-1)
					option3 = random.randi_range(0, weapon_container.get_child_count()-1)
				option1_button.update_texture(option1)
				option2_button.update_texture(option2)
				option3_button.update_texture(option3)
			if levels_cached > 0:
				levels_display.text = str(levels_cached+1) + " Level Ups"
			else:
				levels_display.text = "Level Up"
		else:
			autolevel_display.visible = true
			upgrade_weapon(random.randi_range(0, weapon_container.get_child_count()-1))

func update_health(minim,value,maxim):
	health_bar.min_value = minim
	health_bar.max_value = maxim
	health_bar.value = value

func update_experience(minim,value,maxim):
	experience_bar.min_value = minim
	experience_bar.max_value = maxim
	experience_bar.value = value

func add_weapon(weapon : Weapon):
	var instance = weapon_scene.instantiate()
	instance.profile = weapon
	weapon_container.add_child.call_deferred(instance)

func upgrade_weapon(index : int):
	var child = weapon_container.get_child(index)
	child.upgrade()

func update_inventory():
	for child in inventory.get_children():
		child.queue_free()
	for child in weapon_container.get_children():
		var display = TextureRect.new()
		display.texture = child.profile.display
		display.custom_minimum_size = Vector2(72,72)
		display.stretch_mode = TextureRect.STRETCH_KEEP_CENTERED
		var level_label = Label.new()
		var name_label = Label.new()
		name_label.label_settings = load("res://HUD/Name.tres")
		name_label.custom_minimum_size = Vector2(72,72)
		name_label.position = Vector2(0,-5)
		name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		name_label.vertical_alignment = VERTICAL_ALIGNMENT_TOP
		name_label.text = str(child.profile.name)
		level_label.label_settings = load("res://HUD/Name.tres")
		level_label.custom_minimum_size = Vector2(64,64)
		level_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		level_label.vertical_alignment = VERTICAL_ALIGNMENT_BOTTOM
		level_label.text = str(child.level+1)
		display.add_child(level_label)
		display.add_child(name_label)
		inventory.add_child(display)
		inventory.scale = Vector2(min(1,5.0/weapon_container.get_child_count()),min(1,5.0/weapon_container.get_child_count()))

func update_level_tooltip(option):
	tooltip_label.text = "Upgrade"
	tooltip_box.visible = true
	if option is int:
		var child = weapon_container.get_child(option)
		if round(child.profile.damage.x + child.profile.damage.y) != round(child.profile.damage.x):
			tooltip_label.text += ", +" + str(round(child.profile.damage.x + child.profile.damage.y)-round(child.profile.damage.x)) + " damage"

		if round(child.profile.spread.x + child.profile.spread.y) != round(child.profile.spread.x):
			tooltip_label.text += ", +" + str(round(child.profile.spread.x + child.profile.spread.y)-round(child.profile.spread.x)) + " spread"

		if round(child.profile.multishot.x + child.profile.multishot.y) != round(child.profile.multishot.x):
			tooltip_label.text += ", +" + str(round(child.profile.multishot.x + child.profile.multishot.y)-round(child.profile.multishot.x)) + " multishot"

		if round(child.profile.ammo.x + child.profile.ammo.y) != round(child.profile.ammo.x):
			tooltip_label.text += ", +" + str(round(child.profile.ammo.x + child.profile.ammo.y)-round(child.profile.ammo.x)) + " ammo"

		if round(child.profile.unload_time.x + child.profile.unload_time.y) != round(child.profile.unload_time.x):
			tooltip_label.text += ", -" + str(-1*(round(child.profile.unload_time.x + child.profile.unload_time.y)-round(child.profile.unload_time.x))) + " unload time"

		if round(child.profile.reload_time.x + child.profile.reload_time.y) != round(child.profile.reload_time.x):
			tooltip_label.text += ", -" + str(-1*(round(child.profile.reload_time.x + child.profile.reload_time.y)-round(child.profile.reload_time.x))) + " reload time"

		if round(child.profile.pierce.x + child.profile.pierce.y) != round(child.profile.pierce.x):
			tooltip_label.text += ", +" + str(round(child.profile.pierce.x + child.profile.pierce.y)-round(child.profile.pierce.x)) + " more pierce"

		if round(child.profile.speed.x + child.profile.speed.y) != round(child.profile.speed.x):
			tooltip_label.text += ", +" + str(round(child.profile.speed.x + child.profile.speed.y)-round(child.profile.speed.x)) + " faster"

		if round(child.profile.scale.x + child.profile.scale.y) != round(child.profile.scale.x):
			tooltip_label.text += ", +" + str(round(child.profile.scale.x + child.profile.scale.y)-round(child.profile.scale.x)) + " size"

	else:
		tooltip_label.text = option.description

func _on_option_1_pressed():
	if option1_button.scale == Vector2(1,1):
		update_level_tooltip(option1)
		option1_button.scale = Vector2(1.2,1.2)
		option2_button.scale = Vector2(1,1)
		option3_button.scale = Vector2(1,1)
	else:
		option1_button.scale = Vector2(1,1)
		option2_button.scale = Vector2(1,1)
		option3_button.scale = Vector2(1,1)
		tooltip_box.visible = false
		if option1 is int:
			upgrade_weapon(option1)
		else:
			add_weapon(option1)
			possible_weapons.erase(option1)
		level_up_window.visible = false
		if levels_cached > 0:
			levels_cached -= 1
			level_up(0)

func _on_option_2_pressed():
	if option2_button.scale == Vector2(1,1):
		update_level_tooltip(option2)
		option1_button.scale = Vector2(1,1)
		option2_button.scale = Vector2(1.2,1.2)
		option3_button.scale = Vector2(1,1)
	else:
		option1_button.scale = Vector2(1,1)
		option2_button.scale = Vector2(1,1)
		option3_button.scale = Vector2(1,1)
		tooltip_box.visible = false
		if option2 is int:
			upgrade_weapon(option2)
		else:
			add_weapon(option2)
			possible_weapons.erase(option2)
		level_up_window.visible = false
		if levels_cached > 0:
			levels_cached -= 1
			level_up(0)

func _on_option_3_pressed():
	if option3_button.scale == Vector2(1,1):
		update_level_tooltip(option3)
		option1_button.scale = Vector2(1,1)
		option2_button.scale = Vector2(1,1)
		option3_button.scale = Vector2(1.2,1.2)
	else:
		option1_button.scale = Vector2(1,1)
		option2_button.scale = Vector2(1,1)
		option3_button.scale = Vector2(1,1)
		tooltip_box.visible = false
		if option3 is int:
			upgrade_weapon(option3)
		else:
			add_weapon(option3)
			possible_weapons.erase(option3)
		level_up_window.visible = false
		if levels_cached > 0:
			levels_cached -= 1
			level_up(0)
