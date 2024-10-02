extends Node2D

@onready var world = $World
@onready var player = $Player
@onready var enemy_container = $EnemyContainer
@onready var wave_timer = $WaveTimer
var enemy = preload("res://Enemies/Enemy.tscn")
var random = RandomNumberGenerator.new()
var wave : int = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _process(_delta: float):
	world.generate_roads(player.position, Vector2i(24,24))

func spawn_enemies_normal(amount):
	for i in amount-enemy_container.get_child_count():
		var instance = enemy.instantiate()
		instance.global_position = player.global_position+(Vector2(1,0).rotated(random.randf_range(0,2*PI))*random.randi_range(800,1600))
		instance.profile = load("res://Enemies/Resources/Default.tres")
		enemy_container.add_child.call_deferred(instance)


func _on_wave_timer_timeout() -> void:
	spawn_enemies_normal(wave**2)
	wave+= 1
	wave_timer.start()
