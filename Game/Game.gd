extends Node2D

@onready var world = $World
@onready var player = $Player
@onready var enemy_container = $EnemyContainer
@onready var wave_timer = $WaveTimer
var enemy = preload("res://Enemies/Enemy.tscn")
var random = RandomNumberGenerator.new()
var wave : int = 1
var world_profile : World = preload("res://World/Resources/NewYork.tres")

# Called when the node enters the scene tree for the first time.
func _ready():
	world.profile = world_profile

func _process(_delta: float):
	world.generate_roads(player.position, Vector2i(24,24))

func spawn_enemies_normal(amount):
	for i in amount-enemy_container.get_child_count():
		var enemy_index = random.randi_range(0, min(world_profile.possible_enemies.size()-1, wave))
		var instance = enemy.instantiate()
		instance.global_position = player.global_position+(Vector2(1,0).rotated(random.randf_range(0,2*PI))*random.randi_range(800,1600))
		instance.profile = world_profile.possible_enemies[enemy_index]
		enemy_container.add_child.call_deferred(instance)

func _on_wave_timer_timeout() -> void:
	if wave <= 20:
		spawn_enemies_normal(wave**2)
	else:
		spawn_enemies_normal(400)
	wave+= 1
	wave_timer.start()
	print(wave)
	print(min(world_profile.possible_enemies.size()-1, wave))
