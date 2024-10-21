extends Node2D

@onready var world = $World
@onready var player = $Player
@onready var weapon_container = player.get_node("WeaponContainer")
@onready var enemy_container = $EnemyContainer
@onready var experience_container = $ExperienceContainer
@onready var wave_timer = $WaveTimer
@onready var save_file = preload("res://Main Menu/Achievements/LocalAchievements.tres")
var enemy = preload("res://Enemies/Enemy.tscn")
var random = RandomNumberGenerator.new()
var wave : int = 1
var world_profile : World
var character_profile : Character

# Called when the node enters the scene tree for the first time.
func _ready():
	print(world_profile.name)
	world.update_profile(world_profile)
	player.start(character_profile)
	spawn_enemies_normal(2, wave)

func _process(_delta: float):
	world.generate_roads(player.position, Vector2i(24,24))
	achievments_check()

func achievments_check():
	if player.level >= 1 and not save_file.achievements["Reach Level 100 (Unlocks Gummy Bear)"] == true:
		save_file.achievements["Reach Level 100 (Unlocks Gummy Bear)"] = true
		ResourceSaver.save(save_file, "user://save/AchievementLog.tres")
	if wave > 100 and world_profile.name == "Rural" and not save_file.achievements["Reach wave 100 on Rural map (Unlocks Desert map)"] == true:
		save_file.achievements["Reach wave 100 on Rural map (Unlocks Desert map)"]

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
	instance.difficulty = 1+(wave/25.0)
	instance.scale = Vector2i(2,2)
	instance.global_position = player.global_position+(Vector2(1,0).rotated(random.randf_range(0,2*PI))*random.randi_range(800,1600))
	instance.profile = world_profile.possible_enemies[enemy_index]
	enemy_container.add_child.call_deferred(instance)

func spawn_enemies_formation(amount):
	pass

func group_experience():
	var alternate = 0
	if experience_container.get_child_count() > 2000:
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
		spawn_enemies_normal(wave**1.5+3, difficulty)
		if random.randi_range(0,5) == 0:
			spawn_enemies_strong(difficulty)
	else:
		spawn_enemies_normal(400, difficulty*1.1)
		spawn_enemies_strong(difficulty*2)
	wave+= 1
	wave_timer.start()
