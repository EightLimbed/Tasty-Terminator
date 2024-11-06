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
@onready var music = $AudioStreamPlayer
@onready var playlist : Array[AudioStream] = [preload("res://World/Music/TT_RuralTheme.mp3"),preload("res://World/Music/TT_ForestTheme.mp3"),preload("res://World/Music/TT_DesertTheme.mp3"),preload("res://World/Music/TT_WinterTheme.mp3")]
var enemy = preload("res://Enemies/Enemy.tscn")
var random = RandomNumberGenerator.new()
var wave : int = 1
var world_profile : World
var character_profile : Character
var total_revives : int = 2

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
	if player.profile.name == "Candy Corn" and player.level >= 100:
		achievement("Reach level 100 with Candy Corn (Unlocks Ghosts)")
	if wave >= 100 and world_profile.name == "Forest":
		achievement("Reach wave 100 on Forest map (Unlocks Desert map)")
	if wave >= 100 and world_profile.name == "Desert":
		achievement("Reach wave 100 on Desert Map (Unlocks Snow map)")
	if player.level >= 500:
		achievement("Reach level 500")
	if player.level >= 1000:
		achievement("Reach level 1000")
	if total_revives >= 2:
		achievement("Come back from the dead twice in a single game (Unlocks Candy Corn)")
	if wave >= 200 and player.profile.name == "Cookie" and world_profile.name == "Snow":
		achievement("Reach wave 200 with Cookie on Snow map (Unlocks Candy Cane)")

func max_out():
	achievement("Reach wave 200 with Cookie on Snow map (Unlocks Candy Cane)")
	achievement("Reach level 100 (Unlocks Gummy Bear)")
	achievement("Reach level 250 with Cookie (Unlocks Chipper)")
	achievement("Reach wave 100 on Rural map (Unlocks Forest map)")
	achievement("Reach level 250 with Gummy Bear (Unlocks Bear Trap)")
	achievement("Reach level 250 with Donut (Unlocks GLazer)")
	achievement("Reach level 100 with starting weapon (Unlocks Donut)")
	achievement("Reach wave 100 on Forest map (Unlocks Desert map)")
	achievement("Reach wave 100 on Desert Map (Unlocks Snow map)")
	achievement("Come back from the dead twice in a single game (Unlocks Candy Corn)")
	achievement("Reach level 100 with Candy Corn (Unlocks Ghosts)")

func _ready():
	#max_out()
	achievement_popup.visible = false
	world.update_profile(world_profile)
	update_music()
	player.start(character_profile)
	if ResourceLoader.exists("user://save/AchievementLog.tres"):
		save_file = ResourceLoader.load("user://save/AchievementLog.tres")
	player.control_type = save_file.control_type
	spawn_enemies_normal(2)

func _process(_delta: float):
	world.generate_roads(player.position, Vector2i(24,24))
	achievments_check()
	achievement_popup.size.y = achievement_popup_label.size.y+6
	achievement_popup.position.y = 600 - achievement_popup_label.size.y

func achievement(achieve):
	if not save_file.achievements[achieve] == true:
		achievement_popup.visible = true
		save_file.achievements[achieve] = true
		achievement_popup_label.text = achieve
		achievement_popup_timer.start()
		ResourceSaver.save(save_file, "user://save/AchievementLog.tres")
		if ResourceLoader.exists("user://save/AchievementLog.tres"):
			save_file = ResourceLoader.load("user://save/AchievementLog.tres")

func update_music():
	if world_profile.name == "Rural":
		music.stream = playlist[0]
	if world_profile.name == "Forest":
		music.stream = playlist[1]
	if world_profile.name == "Desert":
		music.stream = playlist[2]
	if world_profile.name == "Snow":
		music.stream = playlist[3]
	music.play()

func spawn_enemies_normal(amount):
	for i in amount-enemy_container.get_child_count():
		var enemy_index = random.randi_range(0, min(world_profile.possible_enemies.size()-1, wave))
		var instance = enemy.instantiate()
		instance.difficulty = (1+(wave/40.0)) * player.profile.hunger.x
		instance.global_position = player.global_position+(Vector2(1,0).rotated(random.randf_range(0,2*PI))*random.randi_range(800,1600))
		instance.profile = world_profile.possible_enemies[enemy_index]
		enemy_container.add_child.call_deferred(instance)

func spawn_enemies_strong():
	var enemy_index = random.randi_range(0, min(world_profile.possible_enemies.size()-1, wave))
	var instance = enemy.instantiate()
	instance.difficulty = ((1+(wave/25.0))**2) * player.profile.hunger.x
	instance.scale = Vector2i(2,2)
	instance.global_position = player.global_position+(Vector2(1,0).rotated(random.randf_range(0,2*PI))*random.randi_range(800,1600))
	instance.profile = world_profile.possible_enemies[enemy_index]
	enemy_container.add_child.call_deferred(instance)

func spawn_enemies_formation(_amount):
	pass

func magnet():
	for child in experience_container.get_children():
		child.activated = true

func group_experience():
	if experience_container.get_child_count() > 256:
		var alternate = 0
		for child in experience_container.get_children():
			alternate += 1
			if alternate % 2:
				child.queue_free()
			else:
				child.experience *= 2

func _on_wave_timer_timeout() -> void:
	group_experience()
	if wave**1.5+3 <= 256:
		spawn_enemies_normal(wave**1.5+3)
		if random.randi_range(0,5) == 0:
			spawn_enemies_strong()
	else:
		spawn_enemies_normal(256)
		spawn_enemies_strong()
	wave+= 1
	wave_timer.start()

func _on_achievment_popup_timer_timeout() -> void:
	achievement_popup.visible = false
