extends Node2D

#upgrade window directly increases a cycled stat on the profile, taken from the profiles list of upgradeable stats
var profile : Weapon
var level : int = 0

var projectile_container
var projectile = preload("res://Weapons/Projectile.tscn")
var random = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	profile = load("res://Weapons/Resources/ChocolateChips.tres")
	projectile_container = get_tree().get_root().get_node("Game").get_node("ProjectileContainer")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#need to add collision layers
func shoot():
	var spread_index : int
	var used_spread = []
	multishot = spread.size()

	for i in profile.multishot:
		spread_index = random.randi_range(0,profile.multishot)
		while used_spread.has(spread_index):
			spread_index = random.randi_range(0,spread.size()-1)
		used_spread.append(spread_index)
		var instance = projectile.instantiate()
		#sets starting transfom
		instance.global_position = global_position
		instance.collision_layer = 4
		instance.scale = profile.scale
		instance.frames = profile.projectile_frames
		instance.speed = speed
		instance.time = lifetime
		instance.pierce = pierce
		instance.damage = damage
		projectile_container.add_child.call_deferred(instance)


func upgrade():
	#spread
	profile.spread.x += profile.spread.y
	#multishot
	profile.multishot.x += profile.multishot.y
	#damage
	profile.damage.x += profile.damage.y
	#ammo
	profile.ammo.x += profile.damage.y
	#unload_time
	profile.unload_time.x += profile.unload_time.y
	#reload_time
	profile.reload_time.x += profile.reload_time.y
	#pierce
	profile.pierce.x += profile.pierce.y
	#speed
	profile.speed.x += profile.speed.y
	#scale
	profile.speed.x += profile.speed.y

	#level
	level += 1
