extends Node2D

@onready var world = $World
@onready var player = $Player
@onready var weapon_container = player.get_node("WeaponContainer")
@onready var enemy_container = $EnemyContainer
@onready var experience_container = $ExperienceContainer
@onready var wave_timer = $WaveTimer
var save_file : AchievmentsLog
@onready var achievement_popup = $AchievementPopup/TextureRect
@onready var achievement_popup_label = $AchievementPopup/TextureRect/Label
@onready var achievement_popup_timer = $AchievementPopup/AchievementPopupTimer
var enemy = preload("res://Enemies/Enemy.tscn")
var random = RandomNumberGenerator.new()
var wave : int = 1
var world_profile : World
var character_profile : Character

#do if condition, then achievement([achievement index]), make sure to add achievment to "res://MainMenu/Achievements/LocalAchievements.tres" manually as well
func achievments_check():
	if player.level >= 100:
		achievement("Reach level 100 (Unlocks Gummy Bear)")
	if player.profile.name == "Cookie" and player.level >= 250:
		achievement("Reach level 250 with Cookie (Unlocks Chipper)")
	if wave >= 100 and world_profile.name == "Rural":
		achievement("Reach wave 100 on Rural map (Unlocks Forest map)")
	if player.profile.name == "Gummy Bear" and player.level >= 250:
		achievement("Reach level 250 with Gummy Bear (Unlocks Bear Trap)")
	if player.profile.name == "Donut" and player.level >= 250:
		achievement("Reach level 250 with Donut (Unlocks GLazer)")
	if weapon_container.get_child(0).level >= 100:
		achievement("Reach level 100 with starting weapon (Unlocks Donut)")

func _ready():
	achievement_popup.visible = false
	world.update_profile(world_profile)
	player.start(character_profile)
	if ResourceLoader.exists("user://save/AchievementLog.tres"):
		save_file = ResourceLoader.load("user://save/AchievementLog.tres")
	spawn_enemies_normal(2, wave)

func _process(_delta: float):
	world.generate_roads(player.position, Vector2i(24,24))
	achievments_check()
	achievement_popup.size.y = achievement_popup_label.size.y+6
	achievement_popup.position.y = 600 - achievement_popup_label.size.y

func achievement(achievement):
	if not save_file.achievements[achievement] == true:
		achievement_popup.visible = true
		save_file.achievements[achievement] = true
		achievement_popup_label.text = achievement
		achievement_popup_timer.start()
		ResourceSaver.save(save_file, "user://save/AchievementLog.tres")
		if ResourceLoader.exists("user://save/AchievementLog.tres"):
			save_file = ResourceLoader.load("user://save/AchievementLog.tres")

func spawn_enemies_normal(amount, difficulty):
	for i in amount-enemy_container.get_child_count():
		var enemy_index = random.randi_range(0, min(world_profile.possible_enemies.size()-1, wave))
		var instance = enemy.instantiate()
		instance.difficulty = 1+(wave/25.0)  
		instance.global_position = player.global_position+(Vector2(1,0).rotated(random.randf_range(0,2*PI))*random.randi_range(800,1600))
		instance.profile = world_profile.possible_enemies[enemy_index]
		enemy_container.add_child.call_deferred(instance)

func spawn_enemies_strong(difficulty):
	var enemy_index = random.randi_range(0, min(world_profile.possible_enemies.size()-1, wave))
	var instance = enemy.instantiate()
	instance.difficulty = (1+(wave/25.0))**2
	instance.scale = Vector2i(2,2)
	instance.global_position = player.global_position+(Vector2(1,0).rotated(random.randf_range(0,2*PI))*random.randi_range(800,1600))
	instance.profile = world_profile.possible_enemies[enemy_index]
	enemy_container.add_child.call_deferred(instance)

func spawn_enemies_formation(_amount):
	pass

func group_experience():
	var alternate = 0
	for child in experience_container.get_children():
		alternate += 1
		if alternate % 2:
			child.queue_free()
		else:
			child.experience *= 2

func _on_wave_timer_timeout() -> void:
	group_experience()
	var difficulty = wave*player.profile.hunger.x
	if wave**1.5+3 <= 400:
		spawn_enemies_normal(wave**1.5+3, difficulty*1000)
		if random.randi_range(0,5) == 0:
			spawn_enemies_strong(difficulty)
	else:
		spawn_enemies_normal(400, difficulty*1.1)
		spawn_enemies_strong(difficulty*2)
	wave+= 1
	wave_timer.start()

func _on_achievment_popup_timer_timeout() -> void:
	achievement_popup.visible = false
